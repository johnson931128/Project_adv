#include <SFML/Graphics.hpp>
#include <cmath>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

// ==========================================
// 1. 解析度設定 (Resolution)
// ==========================================
// 我們現在有真正的像素了！
const int nScreenWidth = 1024;
const int nScreenHeight = 512;

// ==========================================
// 2. 遊戲參數 (Game Parameters)
// ==========================================
const int nMapWidth = 16;
const int nMapHeight = 16;

float fPlayerX = 8.0f;
float fPlayerY = 8.0f;
float fPlayerA = 0.0f;
float fFOV = 3.14159f / 4.0f;
float fDepth = 16.0f;
float fSpeed = 5.0f;
float fRotSpeed = 3.0f; // 旋轉速度稍微調快一點

int main()
{
    // 建立 SFML 視窗
    sf::RenderWindow window(sf::VideoMode(nScreenWidth, nScreenHeight), "Raycaster Port - SFML");
    window.setFramerateLimit(60);

    // 建立地圖 (使用 string 即可，不需要 wstring)
    string map;
    map += "#########.......";
    map += "#...............";
    map += "#.......########";
    map += "#..............#";
    map += "#......##......#";
    map += "#......##......#";
    map += "#..............#";
    map += "###............#";
    map += "##.............#";
    map += "#......####..###";
    map += "#......#.......#";
    map += "#......#.......#";
    map += "#..............#";
    map += "#......#########";
    map += "#..............#";
    map += "################";

    // 計時器
    sf::Clock clock;

    while (window.isOpen())
    {
        // --- [時間差計算 Delta Time] ---
        // restart() 會回傳上一次呼叫後經過的時間
        float fElapsedTime = clock.restart().asSeconds();

        // --- [事件處理] ---
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
            // 按 ESC 離開
            if (event.type == sf::Event::KeyPressed && event.key.code == sf::Keyboard::Escape)
                window.close();
        }

        // --- [輸入處理 Input Handling - SFML Style] ---
        // 旋轉
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::A))
            fPlayerA -= fRotSpeed * fElapsedTime;
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::D))
            fPlayerA += fRotSpeed * fElapsedTime;

        // 前進
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::W))
        {
            fPlayerX += sinf(fPlayerA) * fSpeed * fElapsedTime;
            fPlayerY += cosf(fPlayerA) * fSpeed * fElapsedTime;
            if (map[(int)fPlayerY * nMapWidth + (int)fPlayerX] == '#')
            {
                fPlayerX -= sinf(fPlayerA) * fSpeed * fElapsedTime;
                fPlayerY -= cosf(fPlayerA) * fSpeed * fElapsedTime;
            }
        }

        // 後退
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::S))
        {
            fPlayerX -= sinf(fPlayerA) * fSpeed * fElapsedTime;
            fPlayerY -= cosf(fPlayerA) * fSpeed * fElapsedTime;
            if (map[(int)fPlayerY * nMapWidth + (int)fPlayerX] == '#')
            {
                fPlayerX += sinf(fPlayerA) * fSpeed * fElapsedTime;
                fPlayerY += cosf(fPlayerA) * fSpeed * fElapsedTime;
            }
        }

        // --- [繪圖準備] ---
        window.clear(sf::Color::Black); // 清除上一幀

        // 我們使用 VertexArray 來畫線，這比創立 1024 個 RectangleShape 快得多
        // Lines 模式：每兩個點代表一條線
        sf::VertexArray walls(sf::Lines, nScreenWidth * 2);

        // 天空與地板 (畫兩個大矩形當背景)
        sf::RectangleShape sky(sf::Vector2f(nScreenWidth, nScreenHeight / 2));
        sky.setFillColor(sf::Color(0, 0, 139)); // Dark Blue
        window.draw(sky);

        sf::RectangleShape floor(sf::Vector2f(nScreenWidth, nScreenHeight / 2));
        floor.setPosition(0, nScreenHeight / 2);
        floor.setFillColor(sf::Color(34, 139, 34)); // Forest Green
        window.draw(floor);


        // --- [Raycasting 演算法] ---
        // 這裡的邏輯跟 Console 版一模一樣，只是解析度變高了
        for (int x = 0; x < nScreenWidth; x++)
        {
            float fRayAngle = (fPlayerA - fFOV / 2.0f) + ((float)x / (float)nScreenWidth) * fFOV;
            float fDistanceToWall = 0.0f;
            bool bHitWall = false;

            float fEyeX = sinf(fRayAngle);
            float fEyeY = cosf(fRayAngle);

            while (!bHitWall && fDistanceToWall < fDepth)
            {
                fDistanceToWall += 0.1f;
                int nTestX = (int)(fPlayerX + fEyeX * fDistanceToWall);
                int nTestY = (int)(fPlayerY + fEyeY * fDistanceToWall);

                if (nTestX < 0 || nTestX >= nMapWidth || nTestY < 0 || nTestY >= nMapHeight)
                {
                    bHitWall = true;
                    fDistanceToWall = fDepth;
                }
                else
                {
                    if (map[nTestY * nMapWidth + nTestX] == '#')
                        bHitWall = true;
                }
            }

            // 魚眼修正
            float fCorrectedDist = fDistanceToWall * cosf(fRayAngle - fPlayerA);
            
            // 計算牆壁高度
            // 因為現在有 512 像素高，所以牆壁高度會依照比例縮放
            int nCeiling = (float)(nScreenHeight / 2.0) - nScreenHeight / ((float)fCorrectedDist);
            int nFloor = nScreenHeight - nCeiling;

            // --- [色彩著色 Shading] ---
            // 根據距離決定亮度。距離越遠，顏色越暗。
            // 255 是最大亮度，我們用簡單的線性插值
            int colorValue = 255 - (int)(fCorrectedDist * 15); 
            if (colorValue < 0) colorValue = 0;
            
            sf::Color wallColor(colorValue, colorValue, colorValue); // 灰階

            // 設定線條的兩個端點 (頂端與底端)
            // 索引 x*2 是頂點，x*2+1 是底點
            walls[x * 2].position = sf::Vector2f(x, nCeiling);
            walls[x * 2].color = wallColor;

            walls[x * 2 + 1].position = sf::Vector2f(x, nFloor);
            walls[x * 2 + 1].color = wallColor;
        }

        // --- [繪製與顯示] ---
        // 將算好的 1024 條線一次畫上去
        window.draw(walls);
        window.display();
    }

    return 0;
}



















