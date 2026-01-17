#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  // 定義兩個 pipe 所需的 file descriptors
  // p1[0] 為讀取端, p1[1] 為寫入端
  int p1[2]; // 用於 Parent -> Child
  int p2[2]; // 用於 Child -> Parent
  
  // 建立第一條 pipe
  if(pipe(p1) < 0){
    printf("pipe p1 error\n");
    exit(1);
  }

  // 建立第二條 pipe
  if(pipe(p2) < 0){
    printf("pipe p2 error\n");
    exit(1);
  }

  // 目前程式碼先停在這裡，下一步我們處理 fork

  int pid = fork();

  if(pid < 0){
    printf("fork error\n");
    exit(1);
  }

  if(pid == 0){
    // === Child Process (子行程) ===
    // 1. 關閉不需要的端口
    close(p1[1]); // Child 不會寫入 p1
    close(p2[0]); // Child 不會讀取 p2

    char buf;

    // 2. 讀取 Parent 傳來的 byte
    // read 會等待直到有資料進來
    if(read(p1[0], &buf, 1) != 1){
      printf("child read error\n");
      exit(1);
    }

    // 3. 印出收到訊息 (getpid 取得當前 PID)
    printf("%d: received ping\n", getpid());

    // 4. 回傳一個 byte 給 Parent
    if(write(p2[1], &buf, 1) != 1){
      printf("child write error\n");
      exit(1);
    }

    // 5. 關閉使用完的端口並結束
    close(p1[0]);
    close(p2[1]);
    exit(0);

  } else {
    // === Parent Process (父行程) ===
    // 1. 關閉不需要的端口
    close(p1[0]); // Parent 不會讀取 p1
    close(p2[1]); // Parent 不會寫入 p2

    char buf = 'x'; // 傳送的內容不重要，只要有一個 byte 即可

    // 2. 傳送一個 byte 給 Child
    if(write(p1[1], &buf, 1) != 1){
      printf("parent write error\n");
      exit(1);
    }

    // 3. 等待 Child 的回信
    // 這行會卡住，直到 Child 執行 write
    if(read(p2[0], &buf, 1) != 1){
      printf("parent read error\n");
      exit(1);
    }

    // 4. 印出收到訊息
    printf("%d: received pong\n", getpid());

    // 5. 關閉端口並等待孩子結束
    close(p1[1]);
    close(p2[0]);
    wait(0); // 等待 Child 結束，避免殭屍行程

    exit(0);
  }
  // 暫時回傳 0 讓結構完整
  exit(0);
}
