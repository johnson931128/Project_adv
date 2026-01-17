
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
  // p1[0] 為讀取端, p1[1] 為寫入端
  int p1[2]; // 用於 Parent -> Child
  int p2[2]; // 用於 Child -> Parent
  
  // 建立第一條 pipe
  if(pipe(p1) < 0){
   8:	fe840513          	addi	a0,s0,-24
   c:	3e6000ef          	jal	3f2 <pipe>
  10:	04054963          	bltz	a0,62 <main+0x62>
    printf("pipe p1 error\n");
    exit(1);
  }

  // 建立第二條 pipe
  if(pipe(p2) < 0){
  14:	fe040513          	addi	a0,s0,-32
  18:	3da000ef          	jal	3f2 <pipe>
  1c:	04054c63          	bltz	a0,74 <main+0x74>
    exit(1);
  }

  // 目前程式碼先停在這裡，下一步我們處理 fork

  int pid = fork();
  20:	3ba000ef          	jal	3da <fork>

  if(pid < 0){
  24:	06054163          	bltz	a0,86 <main+0x86>
    printf("fork error\n");
    exit(1);
  }

  if(pid == 0){
  28:	0a051f63          	bnez	a0,e6 <main+0xe6>
    // === Child Process (子行程) ===
    // 1. 關閉不需要的端口
    close(p1[1]); // Child 不會寫入 p1
  2c:	fec42503          	lw	a0,-20(s0)
  30:	3da000ef          	jal	40a <close>
    close(p2[0]); // Child 不會讀取 p2
  34:	fe042503          	lw	a0,-32(s0)
  38:	3d2000ef          	jal	40a <close>

    char buf;

    // 2. 讀取 Parent 傳來的 byte
    // read 會等待直到有資料進來
    if(read(p1[0], &buf, 1) != 1){
  3c:	4605                	li	a2,1
  3e:	fdf40593          	addi	a1,s0,-33
  42:	fe842503          	lw	a0,-24(s0)
  46:	3b4000ef          	jal	3fa <read>
  4a:	4785                	li	a5,1
  4c:	04f50663          	beq	a0,a5,98 <main+0x98>
      printf("child read error\n");
  50:	00001517          	auipc	a0,0x1
  54:	99850513          	addi	a0,a0,-1640 # 9e8 <malloc+0x13a>
  58:	7a2000ef          	jal	7fa <printf>
      exit(1);
  5c:	4505                	li	a0,1
  5e:	384000ef          	jal	3e2 <exit>
    printf("pipe p1 error\n");
  62:	00001517          	auipc	a0,0x1
  66:	94e50513          	addi	a0,a0,-1714 # 9b0 <malloc+0x102>
  6a:	790000ef          	jal	7fa <printf>
    exit(1);
  6e:	4505                	li	a0,1
  70:	372000ef          	jal	3e2 <exit>
    printf("pipe p2 error\n");
  74:	00001517          	auipc	a0,0x1
  78:	95450513          	addi	a0,a0,-1708 # 9c8 <malloc+0x11a>
  7c:	77e000ef          	jal	7fa <printf>
    exit(1);
  80:	4505                	li	a0,1
  82:	360000ef          	jal	3e2 <exit>
    printf("fork error\n");
  86:	00001517          	auipc	a0,0x1
  8a:	95250513          	addi	a0,a0,-1710 # 9d8 <malloc+0x12a>
  8e:	76c000ef          	jal	7fa <printf>
    exit(1);
  92:	4505                	li	a0,1
  94:	34e000ef          	jal	3e2 <exit>
    }

    // 3. 印出收到訊息 (getpid 取得當前 PID)
    printf("%d: received ping\n", getpid());
  98:	3ca000ef          	jal	462 <getpid>
  9c:	85aa                	mv	a1,a0
  9e:	00001517          	auipc	a0,0x1
  a2:	96250513          	addi	a0,a0,-1694 # a00 <malloc+0x152>
  a6:	754000ef          	jal	7fa <printf>

    // 4. 回傳一個 byte 給 Parent
    if(write(p2[1], &buf, 1) != 1){
  aa:	4605                	li	a2,1
  ac:	fdf40593          	addi	a1,s0,-33
  b0:	fe442503          	lw	a0,-28(s0)
  b4:	34e000ef          	jal	402 <write>
  b8:	4785                	li	a5,1
  ba:	00f50b63          	beq	a0,a5,d0 <main+0xd0>
      printf("child write error\n");
  be:	00001517          	auipc	a0,0x1
  c2:	95a50513          	addi	a0,a0,-1702 # a18 <malloc+0x16a>
  c6:	734000ef          	jal	7fa <printf>
      exit(1);
  ca:	4505                	li	a0,1
  cc:	316000ef          	jal	3e2 <exit>
    }

    // 5. 關閉使用完的端口並結束
    close(p1[0]);
  d0:	fe842503          	lw	a0,-24(s0)
  d4:	336000ef          	jal	40a <close>
    close(p2[1]);
  d8:	fe442503          	lw	a0,-28(s0)
  dc:	32e000ef          	jal	40a <close>
    exit(0);
  e0:	4501                	li	a0,0
  e2:	300000ef          	jal	3e2 <exit>

  } else {
    // === Parent Process (父行程) ===
    // 1. 關閉不需要的端口
    close(p1[0]); // Parent 不會讀取 p1
  e6:	fe842503          	lw	a0,-24(s0)
  ea:	320000ef          	jal	40a <close>
    close(p2[1]); // Parent 不會寫入 p2
  ee:	fe442503          	lw	a0,-28(s0)
  f2:	318000ef          	jal	40a <close>

    char buf = 'x'; // 傳送的內容不重要，只要有一個 byte 即可
  f6:	07800793          	li	a5,120
  fa:	fcf40fa3          	sb	a5,-33(s0)

    // 2. 傳送一個 byte 給 Child
    if(write(p1[1], &buf, 1) != 1){
  fe:	4605                	li	a2,1
 100:	fdf40593          	addi	a1,s0,-33
 104:	fec42503          	lw	a0,-20(s0)
 108:	2fa000ef          	jal	402 <write>
 10c:	4785                	li	a5,1
 10e:	00f50b63          	beq	a0,a5,124 <main+0x124>
      printf("parent write error\n");
 112:	00001517          	auipc	a0,0x1
 116:	91e50513          	addi	a0,a0,-1762 # a30 <malloc+0x182>
 11a:	6e0000ef          	jal	7fa <printf>
      exit(1);
 11e:	4505                	li	a0,1
 120:	2c2000ef          	jal	3e2 <exit>
    }

    // 3. 等待 Child 的回信
    // 這行會卡住，直到 Child 執行 write
    if(read(p2[0], &buf, 1) != 1){
 124:	4605                	li	a2,1
 126:	fdf40593          	addi	a1,s0,-33
 12a:	fe042503          	lw	a0,-32(s0)
 12e:	2cc000ef          	jal	3fa <read>
 132:	4785                	li	a5,1
 134:	00f50b63          	beq	a0,a5,14a <main+0x14a>
      printf("parent read error\n");
 138:	00001517          	auipc	a0,0x1
 13c:	91050513          	addi	a0,a0,-1776 # a48 <malloc+0x19a>
 140:	6ba000ef          	jal	7fa <printf>
      exit(1);
 144:	4505                	li	a0,1
 146:	29c000ef          	jal	3e2 <exit>
    }

    // 4. 印出收到訊息
    printf("%d: received pong\n", getpid());
 14a:	318000ef          	jal	462 <getpid>
 14e:	85aa                	mv	a1,a0
 150:	00001517          	auipc	a0,0x1
 154:	91050513          	addi	a0,a0,-1776 # a60 <malloc+0x1b2>
 158:	6a2000ef          	jal	7fa <printf>

    // 5. 關閉端口並等待孩子結束
    close(p1[1]);
 15c:	fec42503          	lw	a0,-20(s0)
 160:	2aa000ef          	jal	40a <close>
    close(p2[0]);
 164:	fe042503          	lw	a0,-32(s0)
 168:	2a2000ef          	jal	40a <close>
    wait(0); // 等待 Child 結束，避免殭屍行程
 16c:	4501                	li	a0,0
 16e:	27c000ef          	jal	3ea <wait>

    exit(0);
 172:	4501                	li	a0,0
 174:	26e000ef          	jal	3e2 <exit>

0000000000000178 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 178:	1141                	addi	sp,sp,-16
 17a:	e406                	sd	ra,8(sp)
 17c:	e022                	sd	s0,0(sp)
 17e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 180:	e81ff0ef          	jal	0 <main>
  exit(0);
 184:	4501                	li	a0,0
 186:	25c000ef          	jal	3e2 <exit>

000000000000018a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 190:	87aa                	mv	a5,a0
 192:	0585                	addi	a1,a1,1
 194:	0785                	addi	a5,a5,1
 196:	fff5c703          	lbu	a4,-1(a1)
 19a:	fee78fa3          	sb	a4,-1(a5)
 19e:	fb75                	bnez	a4,192 <strcpy+0x8>
    ;
  return os;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb91                	beqz	a5,1c4 <strcmp+0x1e>
 1b2:	0005c703          	lbu	a4,0(a1)
 1b6:	00f71763          	bne	a4,a5,1c4 <strcmp+0x1e>
    p++, q++;
 1ba:	0505                	addi	a0,a0,1
 1bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	fbe5                	bnez	a5,1b2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c4:	0005c503          	lbu	a0,0(a1)
}
 1c8:	40a7853b          	subw	a0,a5,a0
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret

00000000000001d2 <strlen>:

uint
strlen(const char *s)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	cf91                	beqz	a5,1f8 <strlen+0x26>
 1de:	0505                	addi	a0,a0,1
 1e0:	87aa                	mv	a5,a0
 1e2:	86be                	mv	a3,a5
 1e4:	0785                	addi	a5,a5,1
 1e6:	fff7c703          	lbu	a4,-1(a5)
 1ea:	ff65                	bnez	a4,1e2 <strlen+0x10>
 1ec:	40a6853b          	subw	a0,a3,a0
 1f0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret
  for(n = 0; s[n]; n++)
 1f8:	4501                	li	a0,0
 1fa:	bfe5                	j	1f2 <strlen+0x20>

00000000000001fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 202:	ca19                	beqz	a2,218 <memset+0x1c>
 204:	87aa                	mv	a5,a0
 206:	1602                	slli	a2,a2,0x20
 208:	9201                	srli	a2,a2,0x20
 20a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 20e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 212:	0785                	addi	a5,a5,1
 214:	fee79de3          	bne	a5,a4,20e <memset+0x12>
  }
  return dst;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret

000000000000021e <strchr>:

char*
strchr(const char *s, char c)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
  for(; *s; s++)
 224:	00054783          	lbu	a5,0(a0)
 228:	cb99                	beqz	a5,23e <strchr+0x20>
    if(*s == c)
 22a:	00f58763          	beq	a1,a5,238 <strchr+0x1a>
  for(; *s; s++)
 22e:	0505                	addi	a0,a0,1
 230:	00054783          	lbu	a5,0(a0)
 234:	fbfd                	bnez	a5,22a <strchr+0xc>
      return (char*)s;
  return 0;
 236:	4501                	li	a0,0
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
  return 0;
 23e:	4501                	li	a0,0
 240:	bfe5                	j	238 <strchr+0x1a>

0000000000000242 <gets>:

char*
gets(char *buf, int max)
{
 242:	711d                	addi	sp,sp,-96
 244:	ec86                	sd	ra,88(sp)
 246:	e8a2                	sd	s0,80(sp)
 248:	e4a6                	sd	s1,72(sp)
 24a:	e0ca                	sd	s2,64(sp)
 24c:	fc4e                	sd	s3,56(sp)
 24e:	f852                	sd	s4,48(sp)
 250:	f456                	sd	s5,40(sp)
 252:	f05a                	sd	s6,32(sp)
 254:	ec5e                	sd	s7,24(sp)
 256:	1080                	addi	s0,sp,96
 258:	8baa                	mv	s7,a0
 25a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25c:	892a                	mv	s2,a0
 25e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 260:	4aa9                	li	s5,10
 262:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 264:	89a6                	mv	s3,s1
 266:	2485                	addiw	s1,s1,1
 268:	0344d663          	bge	s1,s4,294 <gets+0x52>
    cc = read(0, &c, 1);
 26c:	4605                	li	a2,1
 26e:	faf40593          	addi	a1,s0,-81
 272:	4501                	li	a0,0
 274:	186000ef          	jal	3fa <read>
    if(cc < 1)
 278:	00a05e63          	blez	a0,294 <gets+0x52>
    buf[i++] = c;
 27c:	faf44783          	lbu	a5,-81(s0)
 280:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 284:	01578763          	beq	a5,s5,292 <gets+0x50>
 288:	0905                	addi	s2,s2,1
 28a:	fd679de3          	bne	a5,s6,264 <gets+0x22>
    buf[i++] = c;
 28e:	89a6                	mv	s3,s1
 290:	a011                	j	294 <gets+0x52>
 292:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 294:	99de                	add	s3,s3,s7
 296:	00098023          	sb	zero,0(s3)
  return buf;
}
 29a:	855e                	mv	a0,s7
 29c:	60e6                	ld	ra,88(sp)
 29e:	6446                	ld	s0,80(sp)
 2a0:	64a6                	ld	s1,72(sp)
 2a2:	6906                	ld	s2,64(sp)
 2a4:	79e2                	ld	s3,56(sp)
 2a6:	7a42                	ld	s4,48(sp)
 2a8:	7aa2                	ld	s5,40(sp)
 2aa:	7b02                	ld	s6,32(sp)
 2ac:	6be2                	ld	s7,24(sp)
 2ae:	6125                	addi	sp,sp,96
 2b0:	8082                	ret

00000000000002b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b2:	1101                	addi	sp,sp,-32
 2b4:	ec06                	sd	ra,24(sp)
 2b6:	e822                	sd	s0,16(sp)
 2b8:	e04a                	sd	s2,0(sp)
 2ba:	1000                	addi	s0,sp,32
 2bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2be:	4581                	li	a1,0
 2c0:	162000ef          	jal	422 <open>
  if(fd < 0)
 2c4:	02054263          	bltz	a0,2e8 <stat+0x36>
 2c8:	e426                	sd	s1,8(sp)
 2ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2cc:	85ca                	mv	a1,s2
 2ce:	16c000ef          	jal	43a <fstat>
 2d2:	892a                	mv	s2,a0
  close(fd);
 2d4:	8526                	mv	a0,s1
 2d6:	134000ef          	jal	40a <close>
  return r;
 2da:	64a2                	ld	s1,8(sp)
}
 2dc:	854a                	mv	a0,s2
 2de:	60e2                	ld	ra,24(sp)
 2e0:	6442                	ld	s0,16(sp)
 2e2:	6902                	ld	s2,0(sp)
 2e4:	6105                	addi	sp,sp,32
 2e6:	8082                	ret
    return -1;
 2e8:	597d                	li	s2,-1
 2ea:	bfcd                	j	2dc <stat+0x2a>

00000000000002ec <atoi>:

int
atoi(const char *s)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f2:	00054683          	lbu	a3,0(a0)
 2f6:	fd06879b          	addiw	a5,a3,-48
 2fa:	0ff7f793          	zext.b	a5,a5
 2fe:	4625                	li	a2,9
 300:	02f66863          	bltu	a2,a5,330 <atoi+0x44>
 304:	872a                	mv	a4,a0
  n = 0;
 306:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 308:	0705                	addi	a4,a4,1
 30a:	0025179b          	slliw	a5,a0,0x2
 30e:	9fa9                	addw	a5,a5,a0
 310:	0017979b          	slliw	a5,a5,0x1
 314:	9fb5                	addw	a5,a5,a3
 316:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 31a:	00074683          	lbu	a3,0(a4)
 31e:	fd06879b          	addiw	a5,a3,-48
 322:	0ff7f793          	zext.b	a5,a5
 326:	fef671e3          	bgeu	a2,a5,308 <atoi+0x1c>
  return n;
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  n = 0;
 330:	4501                	li	a0,0
 332:	bfe5                	j	32a <atoi+0x3e>

0000000000000334 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 33a:	02b57463          	bgeu	a0,a1,362 <memmove+0x2e>
    while(n-- > 0)
 33e:	00c05f63          	blez	a2,35c <memmove+0x28>
 342:	1602                	slli	a2,a2,0x20
 344:	9201                	srli	a2,a2,0x20
 346:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 34a:	872a                	mv	a4,a0
      *dst++ = *src++;
 34c:	0585                	addi	a1,a1,1
 34e:	0705                	addi	a4,a4,1
 350:	fff5c683          	lbu	a3,-1(a1)
 354:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 358:	fef71ae3          	bne	a4,a5,34c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 35c:	6422                	ld	s0,8(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
    dst += n;
 362:	00c50733          	add	a4,a0,a2
    src += n;
 366:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 368:	fec05ae3          	blez	a2,35c <memmove+0x28>
 36c:	fff6079b          	addiw	a5,a2,-1
 370:	1782                	slli	a5,a5,0x20
 372:	9381                	srli	a5,a5,0x20
 374:	fff7c793          	not	a5,a5
 378:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 37a:	15fd                	addi	a1,a1,-1
 37c:	177d                	addi	a4,a4,-1
 37e:	0005c683          	lbu	a3,0(a1)
 382:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 386:	fee79ae3          	bne	a5,a4,37a <memmove+0x46>
 38a:	bfc9                	j	35c <memmove+0x28>

000000000000038c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 38c:	1141                	addi	sp,sp,-16
 38e:	e422                	sd	s0,8(sp)
 390:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 392:	ca05                	beqz	a2,3c2 <memcmp+0x36>
 394:	fff6069b          	addiw	a3,a2,-1
 398:	1682                	slli	a3,a3,0x20
 39a:	9281                	srli	a3,a3,0x20
 39c:	0685                	addi	a3,a3,1
 39e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3a0:	00054783          	lbu	a5,0(a0)
 3a4:	0005c703          	lbu	a4,0(a1)
 3a8:	00e79863          	bne	a5,a4,3b8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ac:	0505                	addi	a0,a0,1
    p2++;
 3ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b0:	fed518e3          	bne	a0,a3,3a0 <memcmp+0x14>
  }
  return 0;
 3b4:	4501                	li	a0,0
 3b6:	a019                	j	3bc <memcmp+0x30>
      return *p1 - *p2;
 3b8:	40e7853b          	subw	a0,a5,a4
}
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret
  return 0;
 3c2:	4501                	li	a0,0
 3c4:	bfe5                	j	3bc <memcmp+0x30>

00000000000003c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e406                	sd	ra,8(sp)
 3ca:	e022                	sd	s0,0(sp)
 3cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ce:	f67ff0ef          	jal	334 <memmove>
}
 3d2:	60a2                	ld	ra,8(sp)
 3d4:	6402                	ld	s0,0(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret

00000000000003da <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3da:	4885                	li	a7,1
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e2:	4889                	li	a7,2
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ea:	488d                	li	a7,3
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f2:	4891                	li	a7,4
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <read>:
.global read
read:
 li a7, SYS_read
 3fa:	4895                	li	a7,5
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <write>:
.global write
write:
 li a7, SYS_write
 402:	48c1                	li	a7,16
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <close>:
.global close
close:
 li a7, SYS_close
 40a:	48d5                	li	a7,21
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <kill>:
.global kill
kill:
 li a7, SYS_kill
 412:	4899                	li	a7,6
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <exec>:
.global exec
exec:
 li a7, SYS_exec
 41a:	489d                	li	a7,7
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <open>:
.global open
open:
 li a7, SYS_open
 422:	48bd                	li	a7,15
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 42a:	48c5                	li	a7,17
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 432:	48c9                	li	a7,18
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 43a:	48a1                	li	a7,8
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <link>:
.global link
link:
 li a7, SYS_link
 442:	48cd                	li	a7,19
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 44a:	48d1                	li	a7,20
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 452:	48a5                	li	a7,9
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <dup>:
.global dup
dup:
 li a7, SYS_dup
 45a:	48a9                	li	a7,10
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 462:	48ad                	li	a7,11
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 46a:	48b1                	li	a7,12
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 472:	48b5                	li	a7,13
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 47a:	48b9                	li	a7,14
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 482:	1101                	addi	sp,sp,-32
 484:	ec06                	sd	ra,24(sp)
 486:	e822                	sd	s0,16(sp)
 488:	1000                	addi	s0,sp,32
 48a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48e:	4605                	li	a2,1
 490:	fef40593          	addi	a1,s0,-17
 494:	f6fff0ef          	jal	402 <write>
}
 498:	60e2                	ld	ra,24(sp)
 49a:	6442                	ld	s0,16(sp)
 49c:	6105                	addi	sp,sp,32
 49e:	8082                	ret

00000000000004a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a0:	7139                	addi	sp,sp,-64
 4a2:	fc06                	sd	ra,56(sp)
 4a4:	f822                	sd	s0,48(sp)
 4a6:	f426                	sd	s1,40(sp)
 4a8:	0080                	addi	s0,sp,64
 4aa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ac:	c299                	beqz	a3,4b2 <printint+0x12>
 4ae:	0805c963          	bltz	a1,540 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4b2:	2581                	sext.w	a1,a1
  neg = 0;
 4b4:	4881                	li	a7,0
 4b6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4bc:	2601                	sext.w	a2,a2
 4be:	00000517          	auipc	a0,0x0
 4c2:	5c250513          	addi	a0,a0,1474 # a80 <digits>
 4c6:	883a                	mv	a6,a4
 4c8:	2705                	addiw	a4,a4,1
 4ca:	02c5f7bb          	remuw	a5,a1,a2
 4ce:	1782                	slli	a5,a5,0x20
 4d0:	9381                	srli	a5,a5,0x20
 4d2:	97aa                	add	a5,a5,a0
 4d4:	0007c783          	lbu	a5,0(a5)
 4d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4dc:	0005879b          	sext.w	a5,a1
 4e0:	02c5d5bb          	divuw	a1,a1,a2
 4e4:	0685                	addi	a3,a3,1
 4e6:	fec7f0e3          	bgeu	a5,a2,4c6 <printint+0x26>
  if(neg)
 4ea:	00088c63          	beqz	a7,502 <printint+0x62>
    buf[i++] = '-';
 4ee:	fd070793          	addi	a5,a4,-48
 4f2:	00878733          	add	a4,a5,s0
 4f6:	02d00793          	li	a5,45
 4fa:	fef70823          	sb	a5,-16(a4)
 4fe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 502:	02e05a63          	blez	a4,536 <printint+0x96>
 506:	f04a                	sd	s2,32(sp)
 508:	ec4e                	sd	s3,24(sp)
 50a:	fc040793          	addi	a5,s0,-64
 50e:	00e78933          	add	s2,a5,a4
 512:	fff78993          	addi	s3,a5,-1
 516:	99ba                	add	s3,s3,a4
 518:	377d                	addiw	a4,a4,-1
 51a:	1702                	slli	a4,a4,0x20
 51c:	9301                	srli	a4,a4,0x20
 51e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 522:	fff94583          	lbu	a1,-1(s2)
 526:	8526                	mv	a0,s1
 528:	f5bff0ef          	jal	482 <putc>
  while(--i >= 0)
 52c:	197d                	addi	s2,s2,-1
 52e:	ff391ae3          	bne	s2,s3,522 <printint+0x82>
 532:	7902                	ld	s2,32(sp)
 534:	69e2                	ld	s3,24(sp)
}
 536:	70e2                	ld	ra,56(sp)
 538:	7442                	ld	s0,48(sp)
 53a:	74a2                	ld	s1,40(sp)
 53c:	6121                	addi	sp,sp,64
 53e:	8082                	ret
    x = -xx;
 540:	40b005bb          	negw	a1,a1
    neg = 1;
 544:	4885                	li	a7,1
    x = -xx;
 546:	bf85                	j	4b6 <printint+0x16>

0000000000000548 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 548:	711d                	addi	sp,sp,-96
 54a:	ec86                	sd	ra,88(sp)
 54c:	e8a2                	sd	s0,80(sp)
 54e:	e0ca                	sd	s2,64(sp)
 550:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 552:	0005c903          	lbu	s2,0(a1)
 556:	26090863          	beqz	s2,7c6 <vprintf+0x27e>
 55a:	e4a6                	sd	s1,72(sp)
 55c:	fc4e                	sd	s3,56(sp)
 55e:	f852                	sd	s4,48(sp)
 560:	f456                	sd	s5,40(sp)
 562:	f05a                	sd	s6,32(sp)
 564:	ec5e                	sd	s7,24(sp)
 566:	e862                	sd	s8,16(sp)
 568:	e466                	sd	s9,8(sp)
 56a:	8b2a                	mv	s6,a0
 56c:	8a2e                	mv	s4,a1
 56e:	8bb2                	mv	s7,a2
  state = 0;
 570:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 572:	4481                	li	s1,0
 574:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 576:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 57a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 57e:	06c00c93          	li	s9,108
 582:	a005                	j	5a2 <vprintf+0x5a>
        putc(fd, c0);
 584:	85ca                	mv	a1,s2
 586:	855a                	mv	a0,s6
 588:	efbff0ef          	jal	482 <putc>
 58c:	a019                	j	592 <vprintf+0x4a>
    } else if(state == '%'){
 58e:	03598263          	beq	s3,s5,5b2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 592:	2485                	addiw	s1,s1,1
 594:	8726                	mv	a4,s1
 596:	009a07b3          	add	a5,s4,s1
 59a:	0007c903          	lbu	s2,0(a5)
 59e:	20090c63          	beqz	s2,7b6 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5a2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5a6:	fe0994e3          	bnez	s3,58e <vprintf+0x46>
      if(c0 == '%'){
 5aa:	fd579de3          	bne	a5,s5,584 <vprintf+0x3c>
        state = '%';
 5ae:	89be                	mv	s3,a5
 5b0:	b7cd                	j	592 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5b2:	00ea06b3          	add	a3,s4,a4
 5b6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ba:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5bc:	c681                	beqz	a3,5c4 <vprintf+0x7c>
 5be:	9752                	add	a4,a4,s4
 5c0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5c4:	03878f63          	beq	a5,s8,602 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5c8:	05978963          	beq	a5,s9,61a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5cc:	07500713          	li	a4,117
 5d0:	0ee78363          	beq	a5,a4,6b6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5d4:	07800713          	li	a4,120
 5d8:	12e78563          	beq	a5,a4,702 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5dc:	07000713          	li	a4,112
 5e0:	14e78a63          	beq	a5,a4,734 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5e4:	07300713          	li	a4,115
 5e8:	18e78a63          	beq	a5,a4,77c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5ec:	02500713          	li	a4,37
 5f0:	04e79563          	bne	a5,a4,63a <vprintf+0xf2>
        putc(fd, '%');
 5f4:	02500593          	li	a1,37
 5f8:	855a                	mv	a0,s6
 5fa:	e89ff0ef          	jal	482 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bf49                	j	592 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 602:	008b8913          	addi	s2,s7,8
 606:	4685                	li	a3,1
 608:	4629                	li	a2,10
 60a:	000ba583          	lw	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	e91ff0ef          	jal	4a0 <printint>
 614:	8bca                	mv	s7,s2
      state = 0;
 616:	4981                	li	s3,0
 618:	bfad                	j	592 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 61a:	06400793          	li	a5,100
 61e:	02f68963          	beq	a3,a5,650 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 622:	06c00793          	li	a5,108
 626:	04f68263          	beq	a3,a5,66a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 62a:	07500793          	li	a5,117
 62e:	0af68063          	beq	a3,a5,6ce <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 632:	07800793          	li	a5,120
 636:	0ef68263          	beq	a3,a5,71a <vprintf+0x1d2>
        putc(fd, '%');
 63a:	02500593          	li	a1,37
 63e:	855a                	mv	a0,s6
 640:	e43ff0ef          	jal	482 <putc>
        putc(fd, c0);
 644:	85ca                	mv	a1,s2
 646:	855a                	mv	a0,s6
 648:	e3bff0ef          	jal	482 <putc>
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b791                	j	592 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 650:	008b8913          	addi	s2,s7,8
 654:	4685                	li	a3,1
 656:	4629                	li	a2,10
 658:	000ba583          	lw	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	e43ff0ef          	jal	4a0 <printint>
        i += 1;
 662:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
        i += 1;
 668:	b72d                	j	592 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 66a:	06400793          	li	a5,100
 66e:	02f60763          	beq	a2,a5,69c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 672:	07500793          	li	a5,117
 676:	06f60963          	beq	a2,a5,6e8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 67a:	07800793          	li	a5,120
 67e:	faf61ee3          	bne	a2,a5,63a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	008b8913          	addi	s2,s7,8
 686:	4681                	li	a3,0
 688:	4641                	li	a2,16
 68a:	000ba583          	lw	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	e11ff0ef          	jal	4a0 <printint>
        i += 2;
 694:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 2;
 69a:	bde5                	j	592 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4685                	li	a3,1
 6a2:	4629                	li	a2,10
 6a4:	000ba583          	lw	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	df7ff0ef          	jal	4a0 <printint>
        i += 2;
 6ae:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
        i += 2;
 6b4:	bdf9                	j	592 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4629                	li	a2,10
 6be:	000ba583          	lw	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	dddff0ef          	jal	4a0 <printint>
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b5d9                	j	592 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4629                	li	a2,10
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	dc5ff0ef          	jal	4a0 <printint>
        i += 1;
 6e0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 1;
 6e6:	b575                	j	592 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4629                	li	a2,10
 6f0:	000ba583          	lw	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	dabff0ef          	jal	4a0 <printint>
        i += 2;
 6fa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
        i += 2;
 700:	bd49                	j	592 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 702:	008b8913          	addi	s2,s7,8
 706:	4681                	li	a3,0
 708:	4641                	li	a2,16
 70a:	000ba583          	lw	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	d91ff0ef          	jal	4a0 <printint>
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	bdad                	j	592 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 71a:	008b8913          	addi	s2,s7,8
 71e:	4681                	li	a3,0
 720:	4641                	li	a2,16
 722:	000ba583          	lw	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	d79ff0ef          	jal	4a0 <printint>
        i += 1;
 72c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 72e:	8bca                	mv	s7,s2
      state = 0;
 730:	4981                	li	s3,0
        i += 1;
 732:	b585                	j	592 <vprintf+0x4a>
 734:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 736:	008b8d13          	addi	s10,s7,8
 73a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 73e:	03000593          	li	a1,48
 742:	855a                	mv	a0,s6
 744:	d3fff0ef          	jal	482 <putc>
  putc(fd, 'x');
 748:	07800593          	li	a1,120
 74c:	855a                	mv	a0,s6
 74e:	d35ff0ef          	jal	482 <putc>
 752:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 754:	00000b97          	auipc	s7,0x0
 758:	32cb8b93          	addi	s7,s7,812 # a80 <digits>
 75c:	03c9d793          	srli	a5,s3,0x3c
 760:	97de                	add	a5,a5,s7
 762:	0007c583          	lbu	a1,0(a5)
 766:	855a                	mv	a0,s6
 768:	d1bff0ef          	jal	482 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 76c:	0992                	slli	s3,s3,0x4
 76e:	397d                	addiw	s2,s2,-1
 770:	fe0916e3          	bnez	s2,75c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 774:	8bea                	mv	s7,s10
      state = 0;
 776:	4981                	li	s3,0
 778:	6d02                	ld	s10,0(sp)
 77a:	bd21                	j	592 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 77c:	008b8993          	addi	s3,s7,8
 780:	000bb903          	ld	s2,0(s7)
 784:	00090f63          	beqz	s2,7a2 <vprintf+0x25a>
        for(; *s; s++)
 788:	00094583          	lbu	a1,0(s2)
 78c:	c195                	beqz	a1,7b0 <vprintf+0x268>
          putc(fd, *s);
 78e:	855a                	mv	a0,s6
 790:	cf3ff0ef          	jal	482 <putc>
        for(; *s; s++)
 794:	0905                	addi	s2,s2,1
 796:	00094583          	lbu	a1,0(s2)
 79a:	f9f5                	bnez	a1,78e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 79c:	8bce                	mv	s7,s3
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bbcd                	j	592 <vprintf+0x4a>
          s = "(null)";
 7a2:	00000917          	auipc	s2,0x0
 7a6:	2d690913          	addi	s2,s2,726 # a78 <malloc+0x1ca>
        for(; *s; s++)
 7aa:	02800593          	li	a1,40
 7ae:	b7c5                	j	78e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7b0:	8bce                	mv	s7,s3
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bbf9                	j	592 <vprintf+0x4a>
 7b6:	64a6                	ld	s1,72(sp)
 7b8:	79e2                	ld	s3,56(sp)
 7ba:	7a42                	ld	s4,48(sp)
 7bc:	7aa2                	ld	s5,40(sp)
 7be:	7b02                	ld	s6,32(sp)
 7c0:	6be2                	ld	s7,24(sp)
 7c2:	6c42                	ld	s8,16(sp)
 7c4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7c6:	60e6                	ld	ra,88(sp)
 7c8:	6446                	ld	s0,80(sp)
 7ca:	6906                	ld	s2,64(sp)
 7cc:	6125                	addi	sp,sp,96
 7ce:	8082                	ret

00000000000007d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d0:	715d                	addi	sp,sp,-80
 7d2:	ec06                	sd	ra,24(sp)
 7d4:	e822                	sd	s0,16(sp)
 7d6:	1000                	addi	s0,sp,32
 7d8:	e010                	sd	a2,0(s0)
 7da:	e414                	sd	a3,8(s0)
 7dc:	e818                	sd	a4,16(s0)
 7de:	ec1c                	sd	a5,24(s0)
 7e0:	03043023          	sd	a6,32(s0)
 7e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ec:	8622                	mv	a2,s0
 7ee:	d5bff0ef          	jal	548 <vprintf>
}
 7f2:	60e2                	ld	ra,24(sp)
 7f4:	6442                	ld	s0,16(sp)
 7f6:	6161                	addi	sp,sp,80
 7f8:	8082                	ret

00000000000007fa <printf>:

void
printf(const char *fmt, ...)
{
 7fa:	711d                	addi	sp,sp,-96
 7fc:	ec06                	sd	ra,24(sp)
 7fe:	e822                	sd	s0,16(sp)
 800:	1000                	addi	s0,sp,32
 802:	e40c                	sd	a1,8(s0)
 804:	e810                	sd	a2,16(s0)
 806:	ec14                	sd	a3,24(s0)
 808:	f018                	sd	a4,32(s0)
 80a:	f41c                	sd	a5,40(s0)
 80c:	03043823          	sd	a6,48(s0)
 810:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 814:	00840613          	addi	a2,s0,8
 818:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 81c:	85aa                	mv	a1,a0
 81e:	4505                	li	a0,1
 820:	d29ff0ef          	jal	548 <vprintf>
}
 824:	60e2                	ld	ra,24(sp)
 826:	6442                	ld	s0,16(sp)
 828:	6125                	addi	sp,sp,96
 82a:	8082                	ret

000000000000082c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 82c:	1141                	addi	sp,sp,-16
 82e:	e422                	sd	s0,8(sp)
 830:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 832:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 836:	00000797          	auipc	a5,0x0
 83a:	7ca7b783          	ld	a5,1994(a5) # 1000 <freep>
 83e:	a02d                	j	868 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 840:	4618                	lw	a4,8(a2)
 842:	9f2d                	addw	a4,a4,a1
 844:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 848:	6398                	ld	a4,0(a5)
 84a:	6310                	ld	a2,0(a4)
 84c:	a83d                	j	88a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 84e:	ff852703          	lw	a4,-8(a0)
 852:	9f31                	addw	a4,a4,a2
 854:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 856:	ff053683          	ld	a3,-16(a0)
 85a:	a091                	j	89e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85c:	6398                	ld	a4,0(a5)
 85e:	00e7e463          	bltu	a5,a4,866 <free+0x3a>
 862:	00e6ea63          	bltu	a3,a4,876 <free+0x4a>
{
 866:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 868:	fed7fae3          	bgeu	a5,a3,85c <free+0x30>
 86c:	6398                	ld	a4,0(a5)
 86e:	00e6e463          	bltu	a3,a4,876 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 872:	fee7eae3          	bltu	a5,a4,866 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 876:	ff852583          	lw	a1,-8(a0)
 87a:	6390                	ld	a2,0(a5)
 87c:	02059813          	slli	a6,a1,0x20
 880:	01c85713          	srli	a4,a6,0x1c
 884:	9736                	add	a4,a4,a3
 886:	fae60de3          	beq	a2,a4,840 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 88a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 88e:	4790                	lw	a2,8(a5)
 890:	02061593          	slli	a1,a2,0x20
 894:	01c5d713          	srli	a4,a1,0x1c
 898:	973e                	add	a4,a4,a5
 89a:	fae68ae3          	beq	a3,a4,84e <free+0x22>
    p->s.ptr = bp->s.ptr;
 89e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8a0:	00000717          	auipc	a4,0x0
 8a4:	76f73023          	sd	a5,1888(a4) # 1000 <freep>
}
 8a8:	6422                	ld	s0,8(sp)
 8aa:	0141                	addi	sp,sp,16
 8ac:	8082                	ret

00000000000008ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ae:	7139                	addi	sp,sp,-64
 8b0:	fc06                	sd	ra,56(sp)
 8b2:	f822                	sd	s0,48(sp)
 8b4:	f426                	sd	s1,40(sp)
 8b6:	ec4e                	sd	s3,24(sp)
 8b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ba:	02051493          	slli	s1,a0,0x20
 8be:	9081                	srli	s1,s1,0x20
 8c0:	04bd                	addi	s1,s1,15
 8c2:	8091                	srli	s1,s1,0x4
 8c4:	0014899b          	addiw	s3,s1,1
 8c8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ca:	00000517          	auipc	a0,0x0
 8ce:	73653503          	ld	a0,1846(a0) # 1000 <freep>
 8d2:	c915                	beqz	a0,906 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d6:	4798                	lw	a4,8(a5)
 8d8:	08977a63          	bgeu	a4,s1,96c <malloc+0xbe>
 8dc:	f04a                	sd	s2,32(sp)
 8de:	e852                	sd	s4,16(sp)
 8e0:	e456                	sd	s5,8(sp)
 8e2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8e4:	8a4e                	mv	s4,s3
 8e6:	0009871b          	sext.w	a4,s3
 8ea:	6685                	lui	a3,0x1
 8ec:	00d77363          	bgeu	a4,a3,8f2 <malloc+0x44>
 8f0:	6a05                	lui	s4,0x1
 8f2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8fa:	00000917          	auipc	s2,0x0
 8fe:	70690913          	addi	s2,s2,1798 # 1000 <freep>
  if(p == (char*)-1)
 902:	5afd                	li	s5,-1
 904:	a081                	j	944 <malloc+0x96>
 906:	f04a                	sd	s2,32(sp)
 908:	e852                	sd	s4,16(sp)
 90a:	e456                	sd	s5,8(sp)
 90c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 90e:	00000797          	auipc	a5,0x0
 912:	70278793          	addi	a5,a5,1794 # 1010 <base>
 916:	00000717          	auipc	a4,0x0
 91a:	6ef73523          	sd	a5,1770(a4) # 1000 <freep>
 91e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 920:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 924:	b7c1                	j	8e4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 926:	6398                	ld	a4,0(a5)
 928:	e118                	sd	a4,0(a0)
 92a:	a8a9                	j	984 <malloc+0xd6>
  hp->s.size = nu;
 92c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 930:	0541                	addi	a0,a0,16
 932:	efbff0ef          	jal	82c <free>
  return freep;
 936:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 93a:	c12d                	beqz	a0,99c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93e:	4798                	lw	a4,8(a5)
 940:	02977263          	bgeu	a4,s1,964 <malloc+0xb6>
    if(p == freep)
 944:	00093703          	ld	a4,0(s2)
 948:	853e                	mv	a0,a5
 94a:	fef719e3          	bne	a4,a5,93c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 94e:	8552                	mv	a0,s4
 950:	b1bff0ef          	jal	46a <sbrk>
  if(p == (char*)-1)
 954:	fd551ce3          	bne	a0,s5,92c <malloc+0x7e>
        return 0;
 958:	4501                	li	a0,0
 95a:	7902                	ld	s2,32(sp)
 95c:	6a42                	ld	s4,16(sp)
 95e:	6aa2                	ld	s5,8(sp)
 960:	6b02                	ld	s6,0(sp)
 962:	a03d                	j	990 <malloc+0xe2>
 964:	7902                	ld	s2,32(sp)
 966:	6a42                	ld	s4,16(sp)
 968:	6aa2                	ld	s5,8(sp)
 96a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 96c:	fae48de3          	beq	s1,a4,926 <malloc+0x78>
        p->s.size -= nunits;
 970:	4137073b          	subw	a4,a4,s3
 974:	c798                	sw	a4,8(a5)
        p += p->s.size;
 976:	02071693          	slli	a3,a4,0x20
 97a:	01c6d713          	srli	a4,a3,0x1c
 97e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 980:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 984:	00000717          	auipc	a4,0x0
 988:	66a73e23          	sd	a0,1660(a4) # 1000 <freep>
      return (void*)(p + 1);
 98c:	01078513          	addi	a0,a5,16
  }
}
 990:	70e2                	ld	ra,56(sp)
 992:	7442                	ld	s0,48(sp)
 994:	74a2                	ld	s1,40(sp)
 996:	69e2                	ld	s3,24(sp)
 998:	6121                	addi	sp,sp,64
 99a:	8082                	ret
 99c:	7902                	ld	s2,32(sp)
 99e:	6a42                	ld	s4,16(sp)
 9a0:	6aa2                	ld	s5,8(sp)
 9a2:	6b02                	ld	s6,0(sp)
 9a4:	b7f5                	j	990 <malloc+0xe2>
