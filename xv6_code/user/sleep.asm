
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char * argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  // 1. 檢查參數個數
  // 必須是 2 個：程式名稱(sleep) + 時間(ticks)
  if(argc != 2){
   8:	4789                	li	a5,2
   a:	00f50c63          	beq	a0,a5,22 <main+0x22>
    fprintf(2, "Usage: sleep ticks\n"); // 輸出錯誤訊息到 stderr (2)
   e:	00001597          	auipc	a1,0x1
  12:	85258593          	addi	a1,a1,-1966 # 860 <malloc+0xf8>
  16:	4509                	li	a0,2
  18:	672000ef          	jal	68a <fprintf>
    exit(1); // 發生錯誤，回傳非 0 值離開
  1c:	4505                	li	a0,1
  1e:	27e000ef          	jal	29c <exit>
  }

  // 2. 將字串參數轉為整數
  // atoi (ASCII to Integer) 是 user/ulib.c 提供的工具
  int ticks = atoi(argv[1]);
  22:	6588                	ld	a0,8(a1)
  24:	182000ef          	jal	1a6 <atoi>

  // 3. 呼叫 System Call
  sleep(ticks);
  28:	304000ef          	jal	32c <sleep>

  // 4. 正常結束
  exit(0);
  2c:	4501                	li	a0,0
  2e:	26e000ef          	jal	29c <exit>

0000000000000032 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  32:	1141                	addi	sp,sp,-16
  34:	e406                	sd	ra,8(sp)
  36:	e022                	sd	s0,0(sp)
  38:	0800                	addi	s0,sp,16
  extern int main();
  main();
  3a:	fc7ff0ef          	jal	0 <main>
  exit(0);
  3e:	4501                	li	a0,0
  40:	25c000ef          	jal	29c <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
    ;
  return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
    p++, q++;
  74:	0505                	addi	a0,a0,1
  76:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	addi	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	86be                	mv	a3,a5
  9e:	0785                	addi	a5,a5,1
  a0:	fff7c703          	lbu	a4,-1(a5)
  a4:	ff65                	bnez	a4,9c <strlen+0x10>
  a6:	40a6853b          	subw	a0,a3,a0
  aa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret
  for(n = 0; s[n]; n++)
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	slli	a2,a2,0x20
  c2:	9201                	srli	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  cc:	0785                	addi	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
  }
  return dst;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
    if(*s == c)
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
  for(; *s; s++)
  e8:	0505                	addi	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
      return (char*)s;
  return 0;
  f0:	4501                	li	a0,0
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	711d                	addi	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11e:	89a6                	mv	s3,s1
 120:	2485                	addiw	s1,s1,1
 122:	0344d663          	bge	s1,s4,14e <gets+0x52>
    cc = read(0, &c, 1);
 126:	4605                	li	a2,1
 128:	faf40593          	addi	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	186000ef          	jal	2b4 <read>
    if(cc < 1)
 132:	00a05e63          	blez	a0,14e <gets+0x52>
    buf[i++] = c;
 136:	faf44783          	lbu	a5,-81(s0)
 13a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13e:	01578763          	beq	a5,s5,14c <gets+0x50>
 142:	0905                	addi	s2,s2,1
 144:	fd679de3          	bne	a5,s6,11e <gets+0x22>
    buf[i++] = c;
 148:	89a6                	mv	s3,s1
 14a:	a011                	j	14e <gets+0x52>
 14c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 14e:	99de                	add	s3,s3,s7
 150:	00098023          	sb	zero,0(s3)
  return buf;
}
 154:	855e                	mv	a0,s7
 156:	60e6                	ld	ra,88(sp)
 158:	6446                	ld	s0,80(sp)
 15a:	64a6                	ld	s1,72(sp)
 15c:	6906                	ld	s2,64(sp)
 15e:	79e2                	ld	s3,56(sp)
 160:	7a42                	ld	s4,48(sp)
 162:	7aa2                	ld	s5,40(sp)
 164:	7b02                	ld	s6,32(sp)
 166:	6be2                	ld	s7,24(sp)
 168:	6125                	addi	sp,sp,96
 16a:	8082                	ret

000000000000016c <stat>:

int
stat(const char *n, struct stat *st)
{
 16c:	1101                	addi	sp,sp,-32
 16e:	ec06                	sd	ra,24(sp)
 170:	e822                	sd	s0,16(sp)
 172:	e04a                	sd	s2,0(sp)
 174:	1000                	addi	s0,sp,32
 176:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 178:	4581                	li	a1,0
 17a:	162000ef          	jal	2dc <open>
  if(fd < 0)
 17e:	02054263          	bltz	a0,1a2 <stat+0x36>
 182:	e426                	sd	s1,8(sp)
 184:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 186:	85ca                	mv	a1,s2
 188:	16c000ef          	jal	2f4 <fstat>
 18c:	892a                	mv	s2,a0
  close(fd);
 18e:	8526                	mv	a0,s1
 190:	134000ef          	jal	2c4 <close>
  return r;
 194:	64a2                	ld	s1,8(sp)
}
 196:	854a                	mv	a0,s2
 198:	60e2                	ld	ra,24(sp)
 19a:	6442                	ld	s0,16(sp)
 19c:	6902                	ld	s2,0(sp)
 19e:	6105                	addi	sp,sp,32
 1a0:	8082                	ret
    return -1;
 1a2:	597d                	li	s2,-1
 1a4:	bfcd                	j	196 <stat+0x2a>

00000000000001a6 <atoi>:

int
atoi(const char *s)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ac:	00054683          	lbu	a3,0(a0)
 1b0:	fd06879b          	addiw	a5,a3,-48
 1b4:	0ff7f793          	zext.b	a5,a5
 1b8:	4625                	li	a2,9
 1ba:	02f66863          	bltu	a2,a5,1ea <atoi+0x44>
 1be:	872a                	mv	a4,a0
  n = 0;
 1c0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c2:	0705                	addi	a4,a4,1
 1c4:	0025179b          	slliw	a5,a0,0x2
 1c8:	9fa9                	addw	a5,a5,a0
 1ca:	0017979b          	slliw	a5,a5,0x1
 1ce:	9fb5                	addw	a5,a5,a3
 1d0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d4:	00074683          	lbu	a3,0(a4)
 1d8:	fd06879b          	addiw	a5,a3,-48
 1dc:	0ff7f793          	zext.b	a5,a5
 1e0:	fef671e3          	bgeu	a2,a5,1c2 <atoi+0x1c>
  return n;
}
 1e4:	6422                	ld	s0,8(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret
  n = 0;
 1ea:	4501                	li	a0,0
 1ec:	bfe5                	j	1e4 <atoi+0x3e>

00000000000001ee <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f4:	02b57463          	bgeu	a0,a1,21c <memmove+0x2e>
    while(n-- > 0)
 1f8:	00c05f63          	blez	a2,216 <memmove+0x28>
 1fc:	1602                	slli	a2,a2,0x20
 1fe:	9201                	srli	a2,a2,0x20
 200:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 204:	872a                	mv	a4,a0
      *dst++ = *src++;
 206:	0585                	addi	a1,a1,1
 208:	0705                	addi	a4,a4,1
 20a:	fff5c683          	lbu	a3,-1(a1)
 20e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 212:	fef71ae3          	bne	a4,a5,206 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
    dst += n;
 21c:	00c50733          	add	a4,a0,a2
    src += n;
 220:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 222:	fec05ae3          	blez	a2,216 <memmove+0x28>
 226:	fff6079b          	addiw	a5,a2,-1
 22a:	1782                	slli	a5,a5,0x20
 22c:	9381                	srli	a5,a5,0x20
 22e:	fff7c793          	not	a5,a5
 232:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 234:	15fd                	addi	a1,a1,-1
 236:	177d                	addi	a4,a4,-1
 238:	0005c683          	lbu	a3,0(a1)
 23c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 240:	fee79ae3          	bne	a5,a4,234 <memmove+0x46>
 244:	bfc9                	j	216 <memmove+0x28>

0000000000000246 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24c:	ca05                	beqz	a2,27c <memcmp+0x36>
 24e:	fff6069b          	addiw	a3,a2,-1
 252:	1682                	slli	a3,a3,0x20
 254:	9281                	srli	a3,a3,0x20
 256:	0685                	addi	a3,a3,1
 258:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 25a:	00054783          	lbu	a5,0(a0)
 25e:	0005c703          	lbu	a4,0(a1)
 262:	00e79863          	bne	a5,a4,272 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 266:	0505                	addi	a0,a0,1
    p2++;
 268:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26a:	fed518e3          	bne	a0,a3,25a <memcmp+0x14>
  }
  return 0;
 26e:	4501                	li	a0,0
 270:	a019                	j	276 <memcmp+0x30>
      return *p1 - *p2;
 272:	40e7853b          	subw	a0,a5,a4
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  return 0;
 27c:	4501                	li	a0,0
 27e:	bfe5                	j	276 <memcmp+0x30>

0000000000000280 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 288:	f67ff0ef          	jal	1ee <memmove>
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 294:	4885                	li	a7,1
 ecall
 296:	00000073          	ecall
 ret
 29a:	8082                	ret

000000000000029c <exit>:
.global exit
exit:
 li a7, SYS_exit
 29c:	4889                	li	a7,2
 ecall
 29e:	00000073          	ecall
 ret
 2a2:	8082                	ret

00000000000002a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a4:	488d                	li	a7,3
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ac:	4891                	li	a7,4
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <read>:
.global read
read:
 li a7, SYS_read
 2b4:	4895                	li	a7,5
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <write>:
.global write
write:
 li a7, SYS_write
 2bc:	48c1                	li	a7,16
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <close>:
.global close
close:
 li a7, SYS_close
 2c4:	48d5                	li	a7,21
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2cc:	4899                	li	a7,6
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d4:	489d                	li	a7,7
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <open>:
.global open
open:
 li a7, SYS_open
 2dc:	48bd                	li	a7,15
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e4:	48c5                	li	a7,17
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2ec:	48c9                	li	a7,18
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f4:	48a1                	li	a7,8
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <link>:
.global link
link:
 li a7, SYS_link
 2fc:	48cd                	li	a7,19
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 304:	48d1                	li	a7,20
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 30c:	48a5                	li	a7,9
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <dup>:
.global dup
dup:
 li a7, SYS_dup
 314:	48a9                	li	a7,10
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 31c:	48ad                	li	a7,11
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 324:	48b1                	li	a7,12
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 32c:	48b5                	li	a7,13
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 334:	48b9                	li	a7,14
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 33c:	1101                	addi	sp,sp,-32
 33e:	ec06                	sd	ra,24(sp)
 340:	e822                	sd	s0,16(sp)
 342:	1000                	addi	s0,sp,32
 344:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 348:	4605                	li	a2,1
 34a:	fef40593          	addi	a1,s0,-17
 34e:	f6fff0ef          	jal	2bc <write>
}
 352:	60e2                	ld	ra,24(sp)
 354:	6442                	ld	s0,16(sp)
 356:	6105                	addi	sp,sp,32
 358:	8082                	ret

000000000000035a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35a:	7139                	addi	sp,sp,-64
 35c:	fc06                	sd	ra,56(sp)
 35e:	f822                	sd	s0,48(sp)
 360:	f426                	sd	s1,40(sp)
 362:	0080                	addi	s0,sp,64
 364:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 366:	c299                	beqz	a3,36c <printint+0x12>
 368:	0805c963          	bltz	a1,3fa <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 36c:	2581                	sext.w	a1,a1
  neg = 0;
 36e:	4881                	li	a7,0
 370:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 374:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 376:	2601                	sext.w	a2,a2
 378:	00000517          	auipc	a0,0x0
 37c:	50850513          	addi	a0,a0,1288 # 880 <digits>
 380:	883a                	mv	a6,a4
 382:	2705                	addiw	a4,a4,1
 384:	02c5f7bb          	remuw	a5,a1,a2
 388:	1782                	slli	a5,a5,0x20
 38a:	9381                	srli	a5,a5,0x20
 38c:	97aa                	add	a5,a5,a0
 38e:	0007c783          	lbu	a5,0(a5)
 392:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 396:	0005879b          	sext.w	a5,a1
 39a:	02c5d5bb          	divuw	a1,a1,a2
 39e:	0685                	addi	a3,a3,1
 3a0:	fec7f0e3          	bgeu	a5,a2,380 <printint+0x26>
  if(neg)
 3a4:	00088c63          	beqz	a7,3bc <printint+0x62>
    buf[i++] = '-';
 3a8:	fd070793          	addi	a5,a4,-48
 3ac:	00878733          	add	a4,a5,s0
 3b0:	02d00793          	li	a5,45
 3b4:	fef70823          	sb	a5,-16(a4)
 3b8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3bc:	02e05a63          	blez	a4,3f0 <printint+0x96>
 3c0:	f04a                	sd	s2,32(sp)
 3c2:	ec4e                	sd	s3,24(sp)
 3c4:	fc040793          	addi	a5,s0,-64
 3c8:	00e78933          	add	s2,a5,a4
 3cc:	fff78993          	addi	s3,a5,-1
 3d0:	99ba                	add	s3,s3,a4
 3d2:	377d                	addiw	a4,a4,-1
 3d4:	1702                	slli	a4,a4,0x20
 3d6:	9301                	srli	a4,a4,0x20
 3d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3dc:	fff94583          	lbu	a1,-1(s2)
 3e0:	8526                	mv	a0,s1
 3e2:	f5bff0ef          	jal	33c <putc>
  while(--i >= 0)
 3e6:	197d                	addi	s2,s2,-1
 3e8:	ff391ae3          	bne	s2,s3,3dc <printint+0x82>
 3ec:	7902                	ld	s2,32(sp)
 3ee:	69e2                	ld	s3,24(sp)
}
 3f0:	70e2                	ld	ra,56(sp)
 3f2:	7442                	ld	s0,48(sp)
 3f4:	74a2                	ld	s1,40(sp)
 3f6:	6121                	addi	sp,sp,64
 3f8:	8082                	ret
    x = -xx;
 3fa:	40b005bb          	negw	a1,a1
    neg = 1;
 3fe:	4885                	li	a7,1
    x = -xx;
 400:	bf85                	j	370 <printint+0x16>

0000000000000402 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 402:	711d                	addi	sp,sp,-96
 404:	ec86                	sd	ra,88(sp)
 406:	e8a2                	sd	s0,80(sp)
 408:	e0ca                	sd	s2,64(sp)
 40a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 40c:	0005c903          	lbu	s2,0(a1)
 410:	26090863          	beqz	s2,680 <vprintf+0x27e>
 414:	e4a6                	sd	s1,72(sp)
 416:	fc4e                	sd	s3,56(sp)
 418:	f852                	sd	s4,48(sp)
 41a:	f456                	sd	s5,40(sp)
 41c:	f05a                	sd	s6,32(sp)
 41e:	ec5e                	sd	s7,24(sp)
 420:	e862                	sd	s8,16(sp)
 422:	e466                	sd	s9,8(sp)
 424:	8b2a                	mv	s6,a0
 426:	8a2e                	mv	s4,a1
 428:	8bb2                	mv	s7,a2
  state = 0;
 42a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 42c:	4481                	li	s1,0
 42e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 430:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 434:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 438:	06c00c93          	li	s9,108
 43c:	a005                	j	45c <vprintf+0x5a>
        putc(fd, c0);
 43e:	85ca                	mv	a1,s2
 440:	855a                	mv	a0,s6
 442:	efbff0ef          	jal	33c <putc>
 446:	a019                	j	44c <vprintf+0x4a>
    } else if(state == '%'){
 448:	03598263          	beq	s3,s5,46c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 44c:	2485                	addiw	s1,s1,1
 44e:	8726                	mv	a4,s1
 450:	009a07b3          	add	a5,s4,s1
 454:	0007c903          	lbu	s2,0(a5)
 458:	20090c63          	beqz	s2,670 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 45c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 460:	fe0994e3          	bnez	s3,448 <vprintf+0x46>
      if(c0 == '%'){
 464:	fd579de3          	bne	a5,s5,43e <vprintf+0x3c>
        state = '%';
 468:	89be                	mv	s3,a5
 46a:	b7cd                	j	44c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 46c:	00ea06b3          	add	a3,s4,a4
 470:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 474:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 476:	c681                	beqz	a3,47e <vprintf+0x7c>
 478:	9752                	add	a4,a4,s4
 47a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 47e:	03878f63          	beq	a5,s8,4bc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 482:	05978963          	beq	a5,s9,4d4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 486:	07500713          	li	a4,117
 48a:	0ee78363          	beq	a5,a4,570 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 48e:	07800713          	li	a4,120
 492:	12e78563          	beq	a5,a4,5bc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 496:	07000713          	li	a4,112
 49a:	14e78a63          	beq	a5,a4,5ee <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 49e:	07300713          	li	a4,115
 4a2:	18e78a63          	beq	a5,a4,636 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4a6:	02500713          	li	a4,37
 4aa:	04e79563          	bne	a5,a4,4f4 <vprintf+0xf2>
        putc(fd, '%');
 4ae:	02500593          	li	a1,37
 4b2:	855a                	mv	a0,s6
 4b4:	e89ff0ef          	jal	33c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4b8:	4981                	li	s3,0
 4ba:	bf49                	j	44c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4bc:	008b8913          	addi	s2,s7,8
 4c0:	4685                	li	a3,1
 4c2:	4629                	li	a2,10
 4c4:	000ba583          	lw	a1,0(s7)
 4c8:	855a                	mv	a0,s6
 4ca:	e91ff0ef          	jal	35a <printint>
 4ce:	8bca                	mv	s7,s2
      state = 0;
 4d0:	4981                	li	s3,0
 4d2:	bfad                	j	44c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4d4:	06400793          	li	a5,100
 4d8:	02f68963          	beq	a3,a5,50a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4dc:	06c00793          	li	a5,108
 4e0:	04f68263          	beq	a3,a5,524 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4e4:	07500793          	li	a5,117
 4e8:	0af68063          	beq	a3,a5,588 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4ec:	07800793          	li	a5,120
 4f0:	0ef68263          	beq	a3,a5,5d4 <vprintf+0x1d2>
        putc(fd, '%');
 4f4:	02500593          	li	a1,37
 4f8:	855a                	mv	a0,s6
 4fa:	e43ff0ef          	jal	33c <putc>
        putc(fd, c0);
 4fe:	85ca                	mv	a1,s2
 500:	855a                	mv	a0,s6
 502:	e3bff0ef          	jal	33c <putc>
      state = 0;
 506:	4981                	li	s3,0
 508:	b791                	j	44c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 50a:	008b8913          	addi	s2,s7,8
 50e:	4685                	li	a3,1
 510:	4629                	li	a2,10
 512:	000ba583          	lw	a1,0(s7)
 516:	855a                	mv	a0,s6
 518:	e43ff0ef          	jal	35a <printint>
        i += 1;
 51c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 51e:	8bca                	mv	s7,s2
      state = 0;
 520:	4981                	li	s3,0
        i += 1;
 522:	b72d                	j	44c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 524:	06400793          	li	a5,100
 528:	02f60763          	beq	a2,a5,556 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 52c:	07500793          	li	a5,117
 530:	06f60963          	beq	a2,a5,5a2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 534:	07800793          	li	a5,120
 538:	faf61ee3          	bne	a2,a5,4f4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 53c:	008b8913          	addi	s2,s7,8
 540:	4681                	li	a3,0
 542:	4641                	li	a2,16
 544:	000ba583          	lw	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	e11ff0ef          	jal	35a <printint>
        i += 2;
 54e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 550:	8bca                	mv	s7,s2
      state = 0;
 552:	4981                	li	s3,0
        i += 2;
 554:	bde5                	j	44c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 556:	008b8913          	addi	s2,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	df7ff0ef          	jal	35a <printint>
        i += 2;
 568:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	8bca                	mv	s7,s2
      state = 0;
 56c:	4981                	li	s3,0
        i += 2;
 56e:	bdf9                	j	44c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 570:	008b8913          	addi	s2,s7,8
 574:	4681                	li	a3,0
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	dddff0ef          	jal	35a <printint>
 582:	8bca                	mv	s7,s2
      state = 0;
 584:	4981                	li	s3,0
 586:	b5d9                	j	44c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 588:	008b8913          	addi	s2,s7,8
 58c:	4681                	li	a3,0
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	dc5ff0ef          	jal	35a <printint>
        i += 1;
 59a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 59c:	8bca                	mv	s7,s2
      state = 0;
 59e:	4981                	li	s3,0
        i += 1;
 5a0:	b575                	j	44c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a2:	008b8913          	addi	s2,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	dabff0ef          	jal	35a <printint>
        i += 2;
 5b4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
        i += 2;
 5ba:	bd49                	j	44c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4641                	li	a2,16
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	d91ff0ef          	jal	35a <printint>
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bdad                	j	44c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d4:	008b8913          	addi	s2,s7,8
 5d8:	4681                	li	a3,0
 5da:	4641                	li	a2,16
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	d79ff0ef          	jal	35a <printint>
        i += 1;
 5e6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e8:	8bca                	mv	s7,s2
      state = 0;
 5ea:	4981                	li	s3,0
        i += 1;
 5ec:	b585                	j	44c <vprintf+0x4a>
 5ee:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5f0:	008b8d13          	addi	s10,s7,8
 5f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5f8:	03000593          	li	a1,48
 5fc:	855a                	mv	a0,s6
 5fe:	d3fff0ef          	jal	33c <putc>
  putc(fd, 'x');
 602:	07800593          	li	a1,120
 606:	855a                	mv	a0,s6
 608:	d35ff0ef          	jal	33c <putc>
 60c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60e:	00000b97          	auipc	s7,0x0
 612:	272b8b93          	addi	s7,s7,626 # 880 <digits>
 616:	03c9d793          	srli	a5,s3,0x3c
 61a:	97de                	add	a5,a5,s7
 61c:	0007c583          	lbu	a1,0(a5)
 620:	855a                	mv	a0,s6
 622:	d1bff0ef          	jal	33c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 626:	0992                	slli	s3,s3,0x4
 628:	397d                	addiw	s2,s2,-1
 62a:	fe0916e3          	bnez	s2,616 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 62e:	8bea                	mv	s7,s10
      state = 0;
 630:	4981                	li	s3,0
 632:	6d02                	ld	s10,0(sp)
 634:	bd21                	j	44c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 636:	008b8993          	addi	s3,s7,8
 63a:	000bb903          	ld	s2,0(s7)
 63e:	00090f63          	beqz	s2,65c <vprintf+0x25a>
        for(; *s; s++)
 642:	00094583          	lbu	a1,0(s2)
 646:	c195                	beqz	a1,66a <vprintf+0x268>
          putc(fd, *s);
 648:	855a                	mv	a0,s6
 64a:	cf3ff0ef          	jal	33c <putc>
        for(; *s; s++)
 64e:	0905                	addi	s2,s2,1
 650:	00094583          	lbu	a1,0(s2)
 654:	f9f5                	bnez	a1,648 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 656:	8bce                	mv	s7,s3
      state = 0;
 658:	4981                	li	s3,0
 65a:	bbcd                	j	44c <vprintf+0x4a>
          s = "(null)";
 65c:	00000917          	auipc	s2,0x0
 660:	21c90913          	addi	s2,s2,540 # 878 <malloc+0x110>
        for(; *s; s++)
 664:	02800593          	li	a1,40
 668:	b7c5                	j	648 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 66a:	8bce                	mv	s7,s3
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bbf9                	j	44c <vprintf+0x4a>
 670:	64a6                	ld	s1,72(sp)
 672:	79e2                	ld	s3,56(sp)
 674:	7a42                	ld	s4,48(sp)
 676:	7aa2                	ld	s5,40(sp)
 678:	7b02                	ld	s6,32(sp)
 67a:	6be2                	ld	s7,24(sp)
 67c:	6c42                	ld	s8,16(sp)
 67e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 680:	60e6                	ld	ra,88(sp)
 682:	6446                	ld	s0,80(sp)
 684:	6906                	ld	s2,64(sp)
 686:	6125                	addi	sp,sp,96
 688:	8082                	ret

000000000000068a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68a:	715d                	addi	sp,sp,-80
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	e010                	sd	a2,0(s0)
 694:	e414                	sd	a3,8(s0)
 696:	e818                	sd	a4,16(s0)
 698:	ec1c                	sd	a5,24(s0)
 69a:	03043023          	sd	a6,32(s0)
 69e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a6:	8622                	mv	a2,s0
 6a8:	d5bff0ef          	jal	402 <vprintf>
}
 6ac:	60e2                	ld	ra,24(sp)
 6ae:	6442                	ld	s0,16(sp)
 6b0:	6161                	addi	sp,sp,80
 6b2:	8082                	ret

00000000000006b4 <printf>:

void
printf(const char *fmt, ...)
{
 6b4:	711d                	addi	sp,sp,-96
 6b6:	ec06                	sd	ra,24(sp)
 6b8:	e822                	sd	s0,16(sp)
 6ba:	1000                	addi	s0,sp,32
 6bc:	e40c                	sd	a1,8(s0)
 6be:	e810                	sd	a2,16(s0)
 6c0:	ec14                	sd	a3,24(s0)
 6c2:	f018                	sd	a4,32(s0)
 6c4:	f41c                	sd	a5,40(s0)
 6c6:	03043823          	sd	a6,48(s0)
 6ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ce:	00840613          	addi	a2,s0,8
 6d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d6:	85aa                	mv	a1,a0
 6d8:	4505                	li	a0,1
 6da:	d29ff0ef          	jal	402 <vprintf>
}
 6de:	60e2                	ld	ra,24(sp)
 6e0:	6442                	ld	s0,16(sp)
 6e2:	6125                	addi	sp,sp,96
 6e4:	8082                	ret

00000000000006e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e6:	1141                	addi	sp,sp,-16
 6e8:	e422                	sd	s0,8(sp)
 6ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f0:	00001797          	auipc	a5,0x1
 6f4:	9107b783          	ld	a5,-1776(a5) # 1000 <freep>
 6f8:	a02d                	j	722 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6fa:	4618                	lw	a4,8(a2)
 6fc:	9f2d                	addw	a4,a4,a1
 6fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 702:	6398                	ld	a4,0(a5)
 704:	6310                	ld	a2,0(a4)
 706:	a83d                	j	744 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 708:	ff852703          	lw	a4,-8(a0)
 70c:	9f31                	addw	a4,a4,a2
 70e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 710:	ff053683          	ld	a3,-16(a0)
 714:	a091                	j	758 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 716:	6398                	ld	a4,0(a5)
 718:	00e7e463          	bltu	a5,a4,720 <free+0x3a>
 71c:	00e6ea63          	bltu	a3,a4,730 <free+0x4a>
{
 720:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 722:	fed7fae3          	bgeu	a5,a3,716 <free+0x30>
 726:	6398                	ld	a4,0(a5)
 728:	00e6e463          	bltu	a3,a4,730 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72c:	fee7eae3          	bltu	a5,a4,720 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 730:	ff852583          	lw	a1,-8(a0)
 734:	6390                	ld	a2,0(a5)
 736:	02059813          	slli	a6,a1,0x20
 73a:	01c85713          	srli	a4,a6,0x1c
 73e:	9736                	add	a4,a4,a3
 740:	fae60de3          	beq	a2,a4,6fa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 744:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 748:	4790                	lw	a2,8(a5)
 74a:	02061593          	slli	a1,a2,0x20
 74e:	01c5d713          	srli	a4,a1,0x1c
 752:	973e                	add	a4,a4,a5
 754:	fae68ae3          	beq	a3,a4,708 <free+0x22>
    p->s.ptr = bp->s.ptr;
 758:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 75a:	00001717          	auipc	a4,0x1
 75e:	8af73323          	sd	a5,-1882(a4) # 1000 <freep>
}
 762:	6422                	ld	s0,8(sp)
 764:	0141                	addi	sp,sp,16
 766:	8082                	ret

0000000000000768 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 768:	7139                	addi	sp,sp,-64
 76a:	fc06                	sd	ra,56(sp)
 76c:	f822                	sd	s0,48(sp)
 76e:	f426                	sd	s1,40(sp)
 770:	ec4e                	sd	s3,24(sp)
 772:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 774:	02051493          	slli	s1,a0,0x20
 778:	9081                	srli	s1,s1,0x20
 77a:	04bd                	addi	s1,s1,15
 77c:	8091                	srli	s1,s1,0x4
 77e:	0014899b          	addiw	s3,s1,1
 782:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 784:	00001517          	auipc	a0,0x1
 788:	87c53503          	ld	a0,-1924(a0) # 1000 <freep>
 78c:	c915                	beqz	a0,7c0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 790:	4798                	lw	a4,8(a5)
 792:	08977a63          	bgeu	a4,s1,826 <malloc+0xbe>
 796:	f04a                	sd	s2,32(sp)
 798:	e852                	sd	s4,16(sp)
 79a:	e456                	sd	s5,8(sp)
 79c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 79e:	8a4e                	mv	s4,s3
 7a0:	0009871b          	sext.w	a4,s3
 7a4:	6685                	lui	a3,0x1
 7a6:	00d77363          	bgeu	a4,a3,7ac <malloc+0x44>
 7aa:	6a05                	lui	s4,0x1
 7ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b4:	00001917          	auipc	s2,0x1
 7b8:	84c90913          	addi	s2,s2,-1972 # 1000 <freep>
  if(p == (char*)-1)
 7bc:	5afd                	li	s5,-1
 7be:	a081                	j	7fe <malloc+0x96>
 7c0:	f04a                	sd	s2,32(sp)
 7c2:	e852                	sd	s4,16(sp)
 7c4:	e456                	sd	s5,8(sp)
 7c6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7c8:	00001797          	auipc	a5,0x1
 7cc:	84878793          	addi	a5,a5,-1976 # 1010 <base>
 7d0:	00001717          	auipc	a4,0x1
 7d4:	82f73823          	sd	a5,-2000(a4) # 1000 <freep>
 7d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7de:	b7c1                	j	79e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7e0:	6398                	ld	a4,0(a5)
 7e2:	e118                	sd	a4,0(a0)
 7e4:	a8a9                	j	83e <malloc+0xd6>
  hp->s.size = nu;
 7e6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ea:	0541                	addi	a0,a0,16
 7ec:	efbff0ef          	jal	6e6 <free>
  return freep;
 7f0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7f4:	c12d                	beqz	a0,856 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f8:	4798                	lw	a4,8(a5)
 7fa:	02977263          	bgeu	a4,s1,81e <malloc+0xb6>
    if(p == freep)
 7fe:	00093703          	ld	a4,0(s2)
 802:	853e                	mv	a0,a5
 804:	fef719e3          	bne	a4,a5,7f6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 808:	8552                	mv	a0,s4
 80a:	b1bff0ef          	jal	324 <sbrk>
  if(p == (char*)-1)
 80e:	fd551ce3          	bne	a0,s5,7e6 <malloc+0x7e>
        return 0;
 812:	4501                	li	a0,0
 814:	7902                	ld	s2,32(sp)
 816:	6a42                	ld	s4,16(sp)
 818:	6aa2                	ld	s5,8(sp)
 81a:	6b02                	ld	s6,0(sp)
 81c:	a03d                	j	84a <malloc+0xe2>
 81e:	7902                	ld	s2,32(sp)
 820:	6a42                	ld	s4,16(sp)
 822:	6aa2                	ld	s5,8(sp)
 824:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 826:	fae48de3          	beq	s1,a4,7e0 <malloc+0x78>
        p->s.size -= nunits;
 82a:	4137073b          	subw	a4,a4,s3
 82e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 830:	02071693          	slli	a3,a4,0x20
 834:	01c6d713          	srli	a4,a3,0x1c
 838:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 83a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 83e:	00000717          	auipc	a4,0x0
 842:	7ca73123          	sd	a0,1986(a4) # 1000 <freep>
      return (void*)(p + 1);
 846:	01078513          	addi	a0,a5,16
  }
}
 84a:	70e2                	ld	ra,56(sp)
 84c:	7442                	ld	s0,48(sp)
 84e:	74a2                	ld	s1,40(sp)
 850:	69e2                	ld	s3,24(sp)
 852:	6121                	addi	sp,sp,64
 854:	8082                	ret
 856:	7902                	ld	s2,32(sp)
 858:	6a42                	ld	s4,16(sp)
 85a:	6aa2                	ld	s5,8(sp)
 85c:	6b02                	ld	s6,0(sp)
 85e:	b7f5                	j	84a <malloc+0xe2>
