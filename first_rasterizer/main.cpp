#include <SFML/Graphics.hpp>
#include <vector>
#include <cmath>      // 用於 std::abs
#include <algorithm>  // 用於 std::swap

// 定義視窗與畫布的寬高
const int W = 800;
const int H = 600;

// 簡單的二維向量結構
struct Vec2{
    float x, y;
};


// --- 1. 最底層的畫點函式 ---
// 功能：檢查邊界，算出記憶體位置，填入顏色
void putPixel(int x, int y, int r, int g, int b, std::vector<sf::Uint8>& pixels) {
    // 安全檢查：如果座標超出螢幕範圍，什麼都不做直接返回
    if (x < 0 || x >= W || y < 0 || y >= H) return;

    // 計算在陣列中的索引位置
    // 每個像素佔 4 bytes (R, G, B, A)
    int index = (y * W + x) * 4;

    // 修改記憶體中的數值
    pixels[index]     = r;   // Red
    pixels[index + 1] = g;   // Green
    pixels[index + 2] = b;   // Blue
    pixels[index + 3] = 255; // Alpha (完全不透明)
}

// --- 2. 畫線演算法 (Bresenham's Line Algorithm) ---
// 功能：在兩點之間算出路徑，並呼叫 putPixel 填滿
void drawLine(int x0, int y0, int x1, int y1, int r, int g, int b, std::vector<sf::Uint8>& pixels) {
    // A. 判斷線是否陡峭 (Steep)
    // 如果 y 的變化比 x 大，代表這條線比較「直」，我們就把 x, y 對調來算
    bool steep = std::abs(y1 - y0) > std::abs(x1 - x0);
    if (steep) {
        std::swap(x0, y0);
        std::swap(x1, y1);
    }

    // B. 判斷是否由右向左畫
    // 我們希望永遠從左邊畫到右邊 (x0 < x1)，這樣迴圈比較好寫
    if (x0 > x1) {
        std::swap(x0, x1);
        std::swap(y0, y1);
    }

    // C. 準備 Bresenham 演算法參數
    int dx = x1 - x0;
    int dy = std::abs(y1 - y0);
    int error = dx / 2;             // 初始誤差值
    int ystep = (y0 < y1) ? 1 : -1; // 決定 y 是往上走還是往下走
    int y = y0;

    // D. 開始畫線迴圈
    for (int x = x0; x <= x1; x++) {
        // 如果剛剛因為陡峭而對調過 x, y，畫圖時要換回來
        if (steep) {
            putPixel(y, x, r, g, b, pixels); 
        } else {
            putPixel(x, y, r, g, b, pixels);
        }

        // 更新誤差值
        error -= dy;
        if (error < 0) {
            y += ystep;     // 誤差累積夠了，y 移動一步
            error += dx;    // 修正誤差
        }
    }
}

int main() {
    // 建立視窗
    sf::RenderWindow window(sf::VideoMode(W, H), "My Software Rasterizer");
    window.setFramerateLimit(60);

    // 準備「顯存」：一個大小為 W * H * 4 的一維陣列
    std::vector<sf::Uint8> pixels(W * H * 4);

    // 初始化背景為黑色
    // std::fill 是 C++ 快速填滿陣列的方法，比手寫 for 迴圈快且乾淨
    std::fill(pixels.begin(), pixels.end(), 0);
    // 因為 Alpha 通道如果是 0 會透明，我們還是手動把 Alpha 設為 255 比較保險
    for (int i = 3; i < pixels.size(); i += 4) {
        pixels[i] = 255;
    }

    // --- 繪圖指令區 (在這裡呼叫我們的函式) ---
    
    // 畫一個大三角形
    // 左邊 (白線)
    drawLine(400, 100, 200, 500, 255, 255, 255, pixels);
    // 右邊 (紅線)
    drawLine(400, 100, 600, 500, 255, 0, 0, pixels);
    // 下面 (綠線)
    drawLine(200, 500, 600, 500, 0, 255, 0, pixels);

    // 畫一個 X (測試斜線)
    drawLine(100, 100, 200, 200, 100, 100, 255, pixels); // 藍色
    drawLine(200, 100, 100, 200, 100, 100, 255, pixels); // 藍色

    // ------------------------------------

    // 建立 SFML Texture (這是給 GPU 看的)
    sf::Texture texture;
    texture.create(W, H); // 挖好坑
    sf::Sprite sprite(texture);

    // 主迴圈
    while (window.isOpen()) {
        sf::Event event;
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed)
                window.close();
        }

        // 1. 上傳數據：把 CPU 的 pixels 陣列複製到 GPU 的 texture
        texture.update(pixels.data());

        // 2. 顯示
        window.clear();
        window.draw(sprite);
        window.display();
    }

    return 0;
}
