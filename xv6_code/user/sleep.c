#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char * argv[])
{
  // 1. 檢查參數個數
  // 必須是 2 個：程式名稱(sleep) + 時間(ticks)
  if(argc != 2){
    fprintf(2, "Usage: sleep ticks\n"); // 輸出錯誤訊息到 stderr (2)
    exit(1); // 發生錯誤，回傳非 0 值離開
  }

  // 2. 將字串參數轉為整數
  // atoi (ASCII to Integer) 是 user/ulib.c 提供的工具
  int ticks = atoi(argv[1]);

  // 3. 呼叫 System Call
  sleep(ticks);

  // 4. 正常結束
  exit(0);
}

