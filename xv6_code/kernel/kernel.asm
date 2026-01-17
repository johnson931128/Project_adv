
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00019117          	auipc	sp,0x19
    80000004:	b3010113          	addi	sp,sp,-1232 # 80018b30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	4a9040ef          	jal	80004cbe <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	c0078793          	addi	a5,a5,-1024 # 80020c30 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	8b490913          	addi	s2,s2,-1868 # 80007900 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	6ca050ef          	jal	80005720 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	752050ef          	jal	800057b8 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	374050ef          	jal	800053f2 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	00008517          	auipc	a0,0x8
    800000de:	82650513          	addi	a0,a0,-2010 # 80007900 <kmem>
    800000e2:	5be050ef          	jal	800056a0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00021517          	auipc	a0,0x21
    800000ee:	b4650513          	addi	a0,a0,-1210 # 80020c30 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	00007497          	auipc	s1,0x7
    8000010c:	7f848493          	addi	s1,s1,2040 # 80007900 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	60e050ef          	jal	80005720 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	00007517          	auipc	a0,0x7
    80000120:	7e450513          	addi	a0,a0,2020 # 80007900 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	692050ef          	jal	800057b8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	00007517          	auipc	a0,0x7
    80000144:	7c050513          	addi	a0,a0,1984 # 80007900 <kmem>
    80000148:	670050ef          	jal	800057b8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde3d1>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	24b000ef          	jal	80000d3a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	00007717          	auipc	a4,0x7
    800002f8:	5dc70713          	addi	a4,a4,1500 # 800078d0 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000308:	233000ef          	jal	80000d3a <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	60b040ef          	jal	80005120 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	538010ef          	jal	80001856 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	3b6040ef          	jal	800046d8 <plicinithart>
  }

  scheduler();        
    80000326:	675000ef          	jal	8000119a <scheduler>
    consoleinit();
    8000032a:	521040ef          	jal	8000504a <consoleinit>
    printfinit();
    8000032e:	0fe050ef          	jal	8000542c <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	5e7040ef          	jal	80005120 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	5db040ef          	jal	80005120 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	5cf040ef          	jal	80005120 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	123000ef          	jal	80000c84 <procinit>
    trapinit();      // trap vectors
    80000366:	4cc010ef          	jal	80001832 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	4ec010ef          	jal	80001856 <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	350040ef          	jal	800046be <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	366040ef          	jal	800046d8 <plicinithart>
    binit();         // buffer cache
    80000376:	313010ef          	jal	80001e88 <binit>
    iinit();         // inode table
    8000037a:	104020ef          	jal	8000247e <iinit>
    fileinit();      // file table
    8000037e:	6b1020ef          	jal	8000322e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	446040ef          	jal	800047c8 <virtio_disk_init>
    userinit();      // first user process
    80000386:	449000ef          	jal	80000fce <userinit>
    __sync_synchronize();
    8000038a:	0ff0000f          	fence
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	00007717          	auipc	a4,0x7
    80000394:	54f72023          	sw	a5,1344(a4) # 800078d0 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a4:	00007797          	auipc	a5,0x7
    800003a8:	5347b783          	ld	a5,1332(a5) # 800078d8 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003b8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	84aa                	mv	s1,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003e4:	02b7fc63          	bgeu	a5,a1,8000041c <walk+0x5a>
    panic("walk");
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	002050ef          	jal	800053f2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003f4:	060a8263          	beqz	s5,80000458 <walk+0x96>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	84aa                	mv	s1,a0
    800003fe:	c139                	beqz	a0,80000444 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000408:	00c4d793          	srli	a5,s1,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde3c7>
    80000418:	036a0063          	beq	s4,s6,80000438 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041c:	0149d933          	srl	s2,s3,s4
    80000420:	1ff97913          	andi	s2,s2,511
    80000424:	090e                	slli	s2,s2,0x3
    80000426:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000428:	00093483          	ld	s1,0(s2)
    8000042c:	0014f793          	andi	a5,s1,1
    80000430:	d3f1                	beqz	a5,800003f4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000432:	80a9                	srli	s1,s1,0xa
    80000434:	04b2                	slli	s1,s1,0xc
    80000436:	b7c5                	j	80000416 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
        return 0;
    80000458:	4501                	li	a0,0
    8000045a:	b7ed                	j	80000444 <walk+0x82>

000000008000045c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000045c:	57fd                	li	a5,-1
    8000045e:	83e9                	srli	a5,a5,0x1a
    80000460:	00b7f463          	bgeu	a5,a1,80000468 <walkaddr+0xc>
    return 0;
    80000464:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000466:	8082                	ret
{
    80000468:	1141                	addi	sp,sp,-16
    8000046a:	e406                	sd	ra,8(sp)
    8000046c:	e022                	sd	s0,0(sp)
    8000046e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000470:	4601                	li	a2,0
    80000472:	f51ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000476:	c105                	beqz	a0,80000496 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000478:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000047a:	0117f693          	andi	a3,a5,17
    8000047e:	4745                	li	a4,17
    return 0;
    80000480:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000482:	00e68663          	beq	a3,a4,8000048e <walkaddr+0x32>
}
    80000486:	60a2                	ld	ra,8(sp)
    80000488:	6402                	ld	s0,0(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret
  pa = PTE2PA(*pte);
    8000048e:	83a9                	srli	a5,a5,0xa
    80000490:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000494:	bfcd                	j	80000486 <walkaddr+0x2a>
    return 0;
    80000496:	4501                	li	a0,0
    80000498:	b7fd                	j	80000486 <walkaddr+0x2a>

000000008000049a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000049a:	715d                	addi	sp,sp,-80
    8000049c:	e486                	sd	ra,72(sp)
    8000049e:	e0a2                	sd	s0,64(sp)
    800004a0:	fc26                	sd	s1,56(sp)
    800004a2:	f84a                	sd	s2,48(sp)
    800004a4:	f44e                	sd	s3,40(sp)
    800004a6:	f052                	sd	s4,32(sp)
    800004a8:	ec56                	sd	s5,24(sp)
    800004aa:	e85a                	sd	s6,16(sp)
    800004ac:	e45e                	sd	s7,8(sp)
    800004ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b0:	03459793          	slli	a5,a1,0x34
    800004b4:	e7a9                	bnez	a5,800004fe <mappages+0x64>
    800004b6:	8aaa                	mv	s5,a0
    800004b8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004ba:	03461793          	slli	a5,a2,0x34
    800004be:	e7b1                	bnez	a5,8000050a <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c0:	ca39                	beqz	a2,80000516 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004c2:	77fd                	lui	a5,0xfffff
    800004c4:	963e                	add	a2,a2,a5
    800004c6:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ca:	892e                	mv	s2,a1
    800004cc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004d0:	6b85                	lui	s7,0x1
    800004d2:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004d6:	4605                	li	a2,1
    800004d8:	85ca                	mv	a1,s2
    800004da:	8556                	mv	a0,s5
    800004dc:	ee7ff0ef          	jal	800003c2 <walk>
    800004e0:	c539                	beqz	a0,8000052e <mappages+0x94>
    if(*pte & PTE_V)
    800004e2:	611c                	ld	a5,0(a0)
    800004e4:	8b85                	andi	a5,a5,1
    800004e6:	ef95                	bnez	a5,80000522 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004e8:	80b1                	srli	s1,s1,0xc
    800004ea:	04aa                	slli	s1,s1,0xa
    800004ec:	0164e4b3          	or	s1,s1,s6
    800004f0:	0014e493          	ori	s1,s1,1
    800004f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800004f6:	05390863          	beq	s2,s3,80000546 <mappages+0xac>
    a += PGSIZE;
    800004fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	bfd9                	j	800004d2 <mappages+0x38>
    panic("mappages: va not aligned");
    800004fe:	00007517          	auipc	a0,0x7
    80000502:	b5a50513          	addi	a0,a0,-1190 # 80007058 <etext+0x58>
    80000506:	6ed040ef          	jal	800053f2 <panic>
    panic("mappages: size not aligned");
    8000050a:	00007517          	auipc	a0,0x7
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80007078 <etext+0x78>
    80000512:	6e1040ef          	jal	800053f2 <panic>
    panic("mappages: size");
    80000516:	00007517          	auipc	a0,0x7
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80007098 <etext+0x98>
    8000051e:	6d5040ef          	jal	800053f2 <panic>
      panic("mappages: remap");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b8650513          	addi	a0,a0,-1146 # 800070a8 <etext+0xa8>
    8000052a:	6c9040ef          	jal	800053f2 <panic>
      return -1;
    8000052e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000530:	60a6                	ld	ra,72(sp)
    80000532:	6406                	ld	s0,64(sp)
    80000534:	74e2                	ld	s1,56(sp)
    80000536:	7942                	ld	s2,48(sp)
    80000538:	79a2                	ld	s3,40(sp)
    8000053a:	7a02                	ld	s4,32(sp)
    8000053c:	6ae2                	ld	s5,24(sp)
    8000053e:	6b42                	ld	s6,16(sp)
    80000540:	6ba2                	ld	s7,8(sp)
    80000542:	6161                	addi	sp,sp,80
    80000544:	8082                	ret
  return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7e5                	j	80000530 <mappages+0x96>

000000008000054a <kvmmap>:
{
    8000054a:	1141                	addi	sp,sp,-16
    8000054c:	e406                	sd	ra,8(sp)
    8000054e:	e022                	sd	s0,0(sp)
    80000550:	0800                	addi	s0,sp,16
    80000552:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000554:	86b2                	mv	a3,a2
    80000556:	863e                	mv	a2,a5
    80000558:	f43ff0ef          	jal	8000049a <mappages>
    8000055c:	e509                	bnez	a0,80000566 <kvmmap+0x1c>
}
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
    panic("kvmmap");
    80000566:	00007517          	auipc	a0,0x7
    8000056a:	b5250513          	addi	a0,a0,-1198 # 800070b8 <etext+0xb8>
    8000056e:	685040ef          	jal	800053f2 <panic>

0000000080000572 <kvmmake>:
{
    80000572:	1101                	addi	sp,sp,-32
    80000574:	ec06                	sd	ra,24(sp)
    80000576:	e822                	sd	s0,16(sp)
    80000578:	e426                	sd	s1,8(sp)
    8000057a:	e04a                	sd	s2,0(sp)
    8000057c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000057e:	b81ff0ef          	jal	800000fe <kalloc>
    80000582:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000584:	6605                	lui	a2,0x1
    80000586:	4581                	li	a1,0
    80000588:	bc7ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000058c:	4719                	li	a4,6
    8000058e:	6685                	lui	a3,0x1
    80000590:	10000637          	lui	a2,0x10000
    80000594:	100005b7          	lui	a1,0x10000
    80000598:	8526                	mv	a0,s1
    8000059a:	fb1ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000059e:	4719                	li	a4,6
    800005a0:	6685                	lui	a3,0x1
    800005a2:	10001637          	lui	a2,0x10001
    800005a6:	100015b7          	lui	a1,0x10001
    800005aa:	8526                	mv	a0,s1
    800005ac:	f9fff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b0:	4719                	li	a4,6
    800005b2:	040006b7          	lui	a3,0x4000
    800005b6:	0c000637          	lui	a2,0xc000
    800005ba:	0c0005b7          	lui	a1,0xc000
    800005be:	8526                	mv	a0,s1
    800005c0:	f8bff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005c4:	00007917          	auipc	s2,0x7
    800005c8:	a3c90913          	addi	s2,s2,-1476 # 80007000 <etext>
    800005cc:	4729                	li	a4,10
    800005ce:	80007697          	auipc	a3,0x80007
    800005d2:	a3268693          	addi	a3,a3,-1486 # 7000 <_entry-0x7fff9000>
    800005d6:	4605                	li	a2,1
    800005d8:	067e                	slli	a2,a2,0x1f
    800005da:	85b2                	mv	a1,a2
    800005dc:	8526                	mv	a0,s1
    800005de:	f6dff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e2:	46c5                	li	a3,17
    800005e4:	06ee                	slli	a3,a3,0x1b
    800005e6:	4719                	li	a4,6
    800005e8:	412686b3          	sub	a3,a3,s2
    800005ec:	864a                	mv	a2,s2
    800005ee:	85ca                	mv	a1,s2
    800005f0:	8526                	mv	a0,s1
    800005f2:	f59ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005f6:	4729                	li	a4,10
    800005f8:	6685                	lui	a3,0x1
    800005fa:	00006617          	auipc	a2,0x6
    800005fe:	a0660613          	addi	a2,a2,-1530 # 80006000 <_trampoline>
    80000602:	040005b7          	lui	a1,0x4000
    80000606:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000608:	05b2                	slli	a1,a1,0xc
    8000060a:	8526                	mv	a0,s1
    8000060c:	f3fff0ef          	jal	8000054a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000610:	8526                	mv	a0,s1
    80000612:	5da000ef          	jal	80000bec <proc_mapstacks>
}
    80000616:	8526                	mv	a0,s1
    80000618:	60e2                	ld	ra,24(sp)
    8000061a:	6442                	ld	s0,16(sp)
    8000061c:	64a2                	ld	s1,8(sp)
    8000061e:	6902                	ld	s2,0(sp)
    80000620:	6105                	addi	sp,sp,32
    80000622:	8082                	ret

0000000080000624 <kvminit>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000062c:	f47ff0ef          	jal	80000572 <kvmmake>
    80000630:	00007797          	auipc	a5,0x7
    80000634:	2aa7b423          	sd	a0,680(a5) # 800078d8 <kernel_pagetable>
}
    80000638:	60a2                	ld	ra,8(sp)
    8000063a:	6402                	ld	s0,0(sp)
    8000063c:	0141                	addi	sp,sp,16
    8000063e:	8082                	ret

0000000080000640 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000640:	715d                	addi	sp,sp,-80
    80000642:	e486                	sd	ra,72(sp)
    80000644:	e0a2                	sd	s0,64(sp)
    80000646:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000648:	03459793          	slli	a5,a1,0x34
    8000064c:	e39d                	bnez	a5,80000672 <uvmunmap+0x32>
    8000064e:	f84a                	sd	s2,48(sp)
    80000650:	f44e                	sd	s3,40(sp)
    80000652:	f052                	sd	s4,32(sp)
    80000654:	ec56                	sd	s5,24(sp)
    80000656:	e85a                	sd	s6,16(sp)
    80000658:	e45e                	sd	s7,8(sp)
    8000065a:	8a2a                	mv	s4,a0
    8000065c:	892e                	mv	s2,a1
    8000065e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000660:	0632                	slli	a2,a2,0xc
    80000662:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000666:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000668:	6b05                	lui	s6,0x1
    8000066a:	0735ff63          	bgeu	a1,s3,800006e8 <uvmunmap+0xa8>
    8000066e:	fc26                	sd	s1,56(sp)
    80000670:	a0a9                	j	800006ba <uvmunmap+0x7a>
    80000672:	fc26                	sd	s1,56(sp)
    80000674:	f84a                	sd	s2,48(sp)
    80000676:	f44e                	sd	s3,40(sp)
    80000678:	f052                	sd	s4,32(sp)
    8000067a:	ec56                	sd	s5,24(sp)
    8000067c:	e85a                	sd	s6,16(sp)
    8000067e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a4050513          	addi	a0,a0,-1472 # 800070c0 <etext+0xc0>
    80000688:	56b040ef          	jal	800053f2 <panic>
      panic("uvmunmap: walk");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a4c50513          	addi	a0,a0,-1460 # 800070d8 <etext+0xd8>
    80000694:	55f040ef          	jal	800053f2 <panic>
      panic("uvmunmap: not mapped");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a5050513          	addi	a0,a0,-1456 # 800070e8 <etext+0xe8>
    800006a0:	553040ef          	jal	800053f2 <panic>
      panic("uvmunmap: not a leaf");
    800006a4:	00007517          	auipc	a0,0x7
    800006a8:	a5c50513          	addi	a0,a0,-1444 # 80007100 <etext+0x100>
    800006ac:	547040ef          	jal	800053f2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006b0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006b4:	995a                	add	s2,s2,s6
    800006b6:	03397863          	bgeu	s2,s3,800006e6 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006ba:	4601                	li	a2,0
    800006bc:	85ca                	mv	a1,s2
    800006be:	8552                	mv	a0,s4
    800006c0:	d03ff0ef          	jal	800003c2 <walk>
    800006c4:	84aa                	mv	s1,a0
    800006c6:	d179                	beqz	a0,8000068c <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    800006c8:	6108                	ld	a0,0(a0)
    800006ca:	00157793          	andi	a5,a0,1
    800006ce:	d7e9                	beqz	a5,80000698 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006d0:	3ff57793          	andi	a5,a0,1023
    800006d4:	fd7788e3          	beq	a5,s7,800006a4 <uvmunmap+0x64>
    if(do_free){
    800006d8:	fc0a8ce3          	beqz	s5,800006b0 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    800006dc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800006de:	0532                	slli	a0,a0,0xc
    800006e0:	93dff0ef          	jal	8000001c <kfree>
    800006e4:	b7f1                	j	800006b0 <uvmunmap+0x70>
    800006e6:	74e2                	ld	s1,56(sp)
    800006e8:	7942                	ld	s2,48(sp)
    800006ea:	79a2                	ld	s3,40(sp)
    800006ec:	7a02                	ld	s4,32(sp)
    800006ee:	6ae2                	ld	s5,24(sp)
    800006f0:	6b42                	ld	s6,16(sp)
    800006f2:	6ba2                	ld	s7,8(sp)
  }
}
    800006f4:	60a6                	ld	ra,72(sp)
    800006f6:	6406                	ld	s0,64(sp)
    800006f8:	6161                	addi	sp,sp,80
    800006fa:	8082                	ret

00000000800006fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800006fc:	1101                	addi	sp,sp,-32
    800006fe:	ec06                	sd	ra,24(sp)
    80000700:	e822                	sd	s0,16(sp)
    80000702:	e426                	sd	s1,8(sp)
    80000704:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000706:	9f9ff0ef          	jal	800000fe <kalloc>
    8000070a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000070c:	c509                	beqz	a0,80000716 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000070e:	6605                	lui	a2,0x1
    80000710:	4581                	li	a1,0
    80000712:	a3dff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000716:	8526                	mv	a0,s1
    80000718:	60e2                	ld	ra,24(sp)
    8000071a:	6442                	ld	s0,16(sp)
    8000071c:	64a2                	ld	s1,8(sp)
    8000071e:	6105                	addi	sp,sp,32
    80000720:	8082                	ret

0000000080000722 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000722:	7179                	addi	sp,sp,-48
    80000724:	f406                	sd	ra,40(sp)
    80000726:	f022                	sd	s0,32(sp)
    80000728:	ec26                	sd	s1,24(sp)
    8000072a:	e84a                	sd	s2,16(sp)
    8000072c:	e44e                	sd	s3,8(sp)
    8000072e:	e052                	sd	s4,0(sp)
    80000730:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000732:	6785                	lui	a5,0x1
    80000734:	04f67063          	bgeu	a2,a5,80000774 <uvmfirst+0x52>
    80000738:	8a2a                	mv	s4,a0
    8000073a:	89ae                	mv	s3,a1
    8000073c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000073e:	9c1ff0ef          	jal	800000fe <kalloc>
    80000742:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000744:	6605                	lui	a2,0x1
    80000746:	4581                	li	a1,0
    80000748:	a07ff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000074c:	4779                	li	a4,30
    8000074e:	86ca                	mv	a3,s2
    80000750:	6605                	lui	a2,0x1
    80000752:	4581                	li	a1,0
    80000754:	8552                	mv	a0,s4
    80000756:	d45ff0ef          	jal	8000049a <mappages>
  memmove(mem, src, sz);
    8000075a:	8626                	mv	a2,s1
    8000075c:	85ce                	mv	a1,s3
    8000075e:	854a                	mv	a0,s2
    80000760:	a4bff0ef          	jal	800001aa <memmove>
}
    80000764:	70a2                	ld	ra,40(sp)
    80000766:	7402                	ld	s0,32(sp)
    80000768:	64e2                	ld	s1,24(sp)
    8000076a:	6942                	ld	s2,16(sp)
    8000076c:	69a2                	ld	s3,8(sp)
    8000076e:	6a02                	ld	s4,0(sp)
    80000770:	6145                	addi	sp,sp,48
    80000772:	8082                	ret
    panic("uvmfirst: more than a page");
    80000774:	00007517          	auipc	a0,0x7
    80000778:	9a450513          	addi	a0,a0,-1628 # 80007118 <etext+0x118>
    8000077c:	477040ef          	jal	800053f2 <panic>

0000000080000780 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000780:	1101                	addi	sp,sp,-32
    80000782:	ec06                	sd	ra,24(sp)
    80000784:	e822                	sd	s0,16(sp)
    80000786:	e426                	sd	s1,8(sp)
    80000788:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000078a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000078c:	00b67d63          	bgeu	a2,a1,800007a6 <uvmdealloc+0x26>
    80000790:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000792:	6785                	lui	a5,0x1
    80000794:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000796:	00f60733          	add	a4,a2,a5
    8000079a:	76fd                	lui	a3,0xfffff
    8000079c:	8f75                	and	a4,a4,a3
    8000079e:	97ae                	add	a5,a5,a1
    800007a0:	8ff5                	and	a5,a5,a3
    800007a2:	00f76863          	bltu	a4,a5,800007b2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007a6:	8526                	mv	a0,s1
    800007a8:	60e2                	ld	ra,24(sp)
    800007aa:	6442                	ld	s0,16(sp)
    800007ac:	64a2                	ld	s1,8(sp)
    800007ae:	6105                	addi	sp,sp,32
    800007b0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007b2:	8f99                	sub	a5,a5,a4
    800007b4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007b6:	4685                	li	a3,1
    800007b8:	0007861b          	sext.w	a2,a5
    800007bc:	85ba                	mv	a1,a4
    800007be:	e83ff0ef          	jal	80000640 <uvmunmap>
    800007c2:	b7d5                	j	800007a6 <uvmdealloc+0x26>

00000000800007c4 <uvmalloc>:
  if(newsz < oldsz)
    800007c4:	08b66f63          	bltu	a2,a1,80000862 <uvmalloc+0x9e>
{
    800007c8:	7139                	addi	sp,sp,-64
    800007ca:	fc06                	sd	ra,56(sp)
    800007cc:	f822                	sd	s0,48(sp)
    800007ce:	ec4e                	sd	s3,24(sp)
    800007d0:	e852                	sd	s4,16(sp)
    800007d2:	e456                	sd	s5,8(sp)
    800007d4:	0080                	addi	s0,sp,64
    800007d6:	8aaa                	mv	s5,a0
    800007d8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007da:	6785                	lui	a5,0x1
    800007dc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007de:	95be                	add	a1,a1,a5
    800007e0:	77fd                	lui	a5,0xfffff
    800007e2:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800007e6:	08c9f063          	bgeu	s3,a2,80000866 <uvmalloc+0xa2>
    800007ea:	f426                	sd	s1,40(sp)
    800007ec:	f04a                	sd	s2,32(sp)
    800007ee:	e05a                	sd	s6,0(sp)
    800007f0:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007f2:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007f6:	909ff0ef          	jal	800000fe <kalloc>
    800007fa:	84aa                	mv	s1,a0
    if(mem == 0){
    800007fc:	c515                	beqz	a0,80000828 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800007fe:	6605                	lui	a2,0x1
    80000800:	4581                	li	a1,0
    80000802:	94dff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000806:	875a                	mv	a4,s6
    80000808:	86a6                	mv	a3,s1
    8000080a:	6605                	lui	a2,0x1
    8000080c:	85ca                	mv	a1,s2
    8000080e:	8556                	mv	a0,s5
    80000810:	c8bff0ef          	jal	8000049a <mappages>
    80000814:	e915                	bnez	a0,80000848 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000816:	6785                	lui	a5,0x1
    80000818:	993e                	add	s2,s2,a5
    8000081a:	fd496ee3          	bltu	s2,s4,800007f6 <uvmalloc+0x32>
  return newsz;
    8000081e:	8552                	mv	a0,s4
    80000820:	74a2                	ld	s1,40(sp)
    80000822:	7902                	ld	s2,32(sp)
    80000824:	6b02                	ld	s6,0(sp)
    80000826:	a811                	j	8000083a <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000828:	864e                	mv	a2,s3
    8000082a:	85ca                	mv	a1,s2
    8000082c:	8556                	mv	a0,s5
    8000082e:	f53ff0ef          	jal	80000780 <uvmdealloc>
      return 0;
    80000832:	4501                	li	a0,0
    80000834:	74a2                	ld	s1,40(sp)
    80000836:	7902                	ld	s2,32(sp)
    80000838:	6b02                	ld	s6,0(sp)
}
    8000083a:	70e2                	ld	ra,56(sp)
    8000083c:	7442                	ld	s0,48(sp)
    8000083e:	69e2                	ld	s3,24(sp)
    80000840:	6a42                	ld	s4,16(sp)
    80000842:	6aa2                	ld	s5,8(sp)
    80000844:	6121                	addi	sp,sp,64
    80000846:	8082                	ret
      kfree(mem);
    80000848:	8526                	mv	a0,s1
    8000084a:	fd2ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000084e:	864e                	mv	a2,s3
    80000850:	85ca                	mv	a1,s2
    80000852:	8556                	mv	a0,s5
    80000854:	f2dff0ef          	jal	80000780 <uvmdealloc>
      return 0;
    80000858:	4501                	li	a0,0
    8000085a:	74a2                	ld	s1,40(sp)
    8000085c:	7902                	ld	s2,32(sp)
    8000085e:	6b02                	ld	s6,0(sp)
    80000860:	bfe9                	j	8000083a <uvmalloc+0x76>
    return oldsz;
    80000862:	852e                	mv	a0,a1
}
    80000864:	8082                	ret
  return newsz;
    80000866:	8532                	mv	a0,a2
    80000868:	bfc9                	j	8000083a <uvmalloc+0x76>

000000008000086a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000086a:	7179                	addi	sp,sp,-48
    8000086c:	f406                	sd	ra,40(sp)
    8000086e:	f022                	sd	s0,32(sp)
    80000870:	ec26                	sd	s1,24(sp)
    80000872:	e84a                	sd	s2,16(sp)
    80000874:	e44e                	sd	s3,8(sp)
    80000876:	e052                	sd	s4,0(sp)
    80000878:	1800                	addi	s0,sp,48
    8000087a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000087c:	84aa                	mv	s1,a0
    8000087e:	6905                	lui	s2,0x1
    80000880:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000882:	4985                	li	s3,1
    80000884:	a819                	j	8000089a <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000886:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000888:	00c79513          	slli	a0,a5,0xc
    8000088c:	fdfff0ef          	jal	8000086a <freewalk>
      pagetable[i] = 0;
    80000890:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000894:	04a1                	addi	s1,s1,8
    80000896:	01248f63          	beq	s1,s2,800008b4 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000089a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000089c:	00f7f713          	andi	a4,a5,15
    800008a0:	ff3703e3          	beq	a4,s3,80000886 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008a4:	8b85                	andi	a5,a5,1
    800008a6:	d7fd                	beqz	a5,80000894 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008a8:	00007517          	auipc	a0,0x7
    800008ac:	89050513          	addi	a0,a0,-1904 # 80007138 <etext+0x138>
    800008b0:	343040ef          	jal	800053f2 <panic>
    }
  }
  kfree((void*)pagetable);
    800008b4:	8552                	mv	a0,s4
    800008b6:	f66ff0ef          	jal	8000001c <kfree>
}
    800008ba:	70a2                	ld	ra,40(sp)
    800008bc:	7402                	ld	s0,32(sp)
    800008be:	64e2                	ld	s1,24(sp)
    800008c0:	6942                	ld	s2,16(sp)
    800008c2:	69a2                	ld	s3,8(sp)
    800008c4:	6a02                	ld	s4,0(sp)
    800008c6:	6145                	addi	sp,sp,48
    800008c8:	8082                	ret

00000000800008ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008ca:	1101                	addi	sp,sp,-32
    800008cc:	ec06                	sd	ra,24(sp)
    800008ce:	e822                	sd	s0,16(sp)
    800008d0:	e426                	sd	s1,8(sp)
    800008d2:	1000                	addi	s0,sp,32
    800008d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800008d6:	e989                	bnez	a1,800008e8 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008d8:	8526                	mv	a0,s1
    800008da:	f91ff0ef          	jal	8000086a <freewalk>
}
    800008de:	60e2                	ld	ra,24(sp)
    800008e0:	6442                	ld	s0,16(sp)
    800008e2:	64a2                	ld	s1,8(sp)
    800008e4:	6105                	addi	sp,sp,32
    800008e6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008e8:	6785                	lui	a5,0x1
    800008ea:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ec:	95be                	add	a1,a1,a5
    800008ee:	4685                	li	a3,1
    800008f0:	00c5d613          	srli	a2,a1,0xc
    800008f4:	4581                	li	a1,0
    800008f6:	d4bff0ef          	jal	80000640 <uvmunmap>
    800008fa:	bff9                	j	800008d8 <uvmfree+0xe>

00000000800008fc <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800008fc:	c65d                	beqz	a2,800009aa <uvmcopy+0xae>
{
    800008fe:	715d                	addi	sp,sp,-80
    80000900:	e486                	sd	ra,72(sp)
    80000902:	e0a2                	sd	s0,64(sp)
    80000904:	fc26                	sd	s1,56(sp)
    80000906:	f84a                	sd	s2,48(sp)
    80000908:	f44e                	sd	s3,40(sp)
    8000090a:	f052                	sd	s4,32(sp)
    8000090c:	ec56                	sd	s5,24(sp)
    8000090e:	e85a                	sd	s6,16(sp)
    80000910:	e45e                	sd	s7,8(sp)
    80000912:	0880                	addi	s0,sp,80
    80000914:	8b2a                	mv	s6,a0
    80000916:	8aae                	mv	s5,a1
    80000918:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000091a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000091c:	4601                	li	a2,0
    8000091e:	85ce                	mv	a1,s3
    80000920:	855a                	mv	a0,s6
    80000922:	aa1ff0ef          	jal	800003c2 <walk>
    80000926:	c121                	beqz	a0,80000966 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000928:	6118                	ld	a4,0(a0)
    8000092a:	00177793          	andi	a5,a4,1
    8000092e:	c3b1                	beqz	a5,80000972 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000930:	00a75593          	srli	a1,a4,0xa
    80000934:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000938:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000093c:	fc2ff0ef          	jal	800000fe <kalloc>
    80000940:	892a                	mv	s2,a0
    80000942:	c129                	beqz	a0,80000984 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000944:	6605                	lui	a2,0x1
    80000946:	85de                	mv	a1,s7
    80000948:	863ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000094c:	8726                	mv	a4,s1
    8000094e:	86ca                	mv	a3,s2
    80000950:	6605                	lui	a2,0x1
    80000952:	85ce                	mv	a1,s3
    80000954:	8556                	mv	a0,s5
    80000956:	b45ff0ef          	jal	8000049a <mappages>
    8000095a:	e115                	bnez	a0,8000097e <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	99be                	add	s3,s3,a5
    80000960:	fb49eee3          	bltu	s3,s4,8000091c <uvmcopy+0x20>
    80000964:	a805                	j	80000994 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000966:	00006517          	auipc	a0,0x6
    8000096a:	7e250513          	addi	a0,a0,2018 # 80007148 <etext+0x148>
    8000096e:	285040ef          	jal	800053f2 <panic>
      panic("uvmcopy: page not present");
    80000972:	00006517          	auipc	a0,0x6
    80000976:	7f650513          	addi	a0,a0,2038 # 80007168 <etext+0x168>
    8000097a:	279040ef          	jal	800053f2 <panic>
      kfree(mem);
    8000097e:	854a                	mv	a0,s2
    80000980:	e9cff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000984:	4685                	li	a3,1
    80000986:	00c9d613          	srli	a2,s3,0xc
    8000098a:	4581                	li	a1,0
    8000098c:	8556                	mv	a0,s5
    8000098e:	cb3ff0ef          	jal	80000640 <uvmunmap>
  return -1;
    80000992:	557d                	li	a0,-1
}
    80000994:	60a6                	ld	ra,72(sp)
    80000996:	6406                	ld	s0,64(sp)
    80000998:	74e2                	ld	s1,56(sp)
    8000099a:	7942                	ld	s2,48(sp)
    8000099c:	79a2                	ld	s3,40(sp)
    8000099e:	7a02                	ld	s4,32(sp)
    800009a0:	6ae2                	ld	s5,24(sp)
    800009a2:	6b42                	ld	s6,16(sp)
    800009a4:	6ba2                	ld	s7,8(sp)
    800009a6:	6161                	addi	sp,sp,80
    800009a8:	8082                	ret
  return 0;
    800009aa:	4501                	li	a0,0
}
    800009ac:	8082                	ret

00000000800009ae <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009ae:	1141                	addi	sp,sp,-16
    800009b0:	e406                	sd	ra,8(sp)
    800009b2:	e022                	sd	s0,0(sp)
    800009b4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009b6:	4601                	li	a2,0
    800009b8:	a0bff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    800009bc:	c901                	beqz	a0,800009cc <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009be:	611c                	ld	a5,0(a0)
    800009c0:	9bbd                	andi	a5,a5,-17
    800009c2:	e11c                	sd	a5,0(a0)
}
    800009c4:	60a2                	ld	ra,8(sp)
    800009c6:	6402                	ld	s0,0(sp)
    800009c8:	0141                	addi	sp,sp,16
    800009ca:	8082                	ret
    panic("uvmclear");
    800009cc:	00006517          	auipc	a0,0x6
    800009d0:	7bc50513          	addi	a0,a0,1980 # 80007188 <etext+0x188>
    800009d4:	21f040ef          	jal	800053f2 <panic>

00000000800009d8 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009d8:	cad1                	beqz	a3,80000a6c <copyout+0x94>
{
    800009da:	711d                	addi	sp,sp,-96
    800009dc:	ec86                	sd	ra,88(sp)
    800009de:	e8a2                	sd	s0,80(sp)
    800009e0:	e4a6                	sd	s1,72(sp)
    800009e2:	fc4e                	sd	s3,56(sp)
    800009e4:	f456                	sd	s5,40(sp)
    800009e6:	f05a                	sd	s6,32(sp)
    800009e8:	ec5e                	sd	s7,24(sp)
    800009ea:	1080                	addi	s0,sp,96
    800009ec:	8baa                	mv	s7,a0
    800009ee:	8aae                	mv	s5,a1
    800009f0:	8b32                	mv	s6,a2
    800009f2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800009f4:	74fd                	lui	s1,0xfffff
    800009f6:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800009f8:	57fd                	li	a5,-1
    800009fa:	83e9                	srli	a5,a5,0x1a
    800009fc:	0697ea63          	bltu	a5,s1,80000a70 <copyout+0x98>
    80000a00:	e0ca                	sd	s2,64(sp)
    80000a02:	f852                	sd	s4,48(sp)
    80000a04:	e862                	sd	s8,16(sp)
    80000a06:	e466                	sd	s9,8(sp)
    80000a08:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a0a:	4cd5                	li	s9,21
    80000a0c:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000a0e:	8c3e                	mv	s8,a5
    80000a10:	a025                	j	80000a38 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000a12:	83a9                	srli	a5,a5,0xa
    80000a14:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a16:	409a8533          	sub	a0,s5,s1
    80000a1a:	0009061b          	sext.w	a2,s2
    80000a1e:	85da                	mv	a1,s6
    80000a20:	953e                	add	a0,a0,a5
    80000a22:	f88ff0ef          	jal	800001aa <memmove>

    len -= n;
    80000a26:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a2a:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a2c:	02098963          	beqz	s3,80000a5e <copyout+0x86>
    if(va0 >= MAXVA)
    80000a30:	054c6263          	bltu	s8,s4,80000a74 <copyout+0x9c>
    80000a34:	84d2                	mv	s1,s4
    80000a36:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a38:	4601                	li	a2,0
    80000a3a:	85a6                	mv	a1,s1
    80000a3c:	855e                	mv	a0,s7
    80000a3e:	985ff0ef          	jal	800003c2 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a42:	c121                	beqz	a0,80000a82 <copyout+0xaa>
    80000a44:	611c                	ld	a5,0(a0)
    80000a46:	0157f713          	andi	a4,a5,21
    80000a4a:	05971b63          	bne	a4,s9,80000aa0 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000a4e:	01a48a33          	add	s4,s1,s10
    80000a52:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000a56:	fb29fee3          	bgeu	s3,s2,80000a12 <copyout+0x3a>
    80000a5a:	894e                	mv	s2,s3
    80000a5c:	bf5d                	j	80000a12 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a5e:	4501                	li	a0,0
    80000a60:	6906                	ld	s2,64(sp)
    80000a62:	7a42                	ld	s4,48(sp)
    80000a64:	6c42                	ld	s8,16(sp)
    80000a66:	6ca2                	ld	s9,8(sp)
    80000a68:	6d02                	ld	s10,0(sp)
    80000a6a:	a015                	j	80000a8e <copyout+0xb6>
    80000a6c:	4501                	li	a0,0
}
    80000a6e:	8082                	ret
      return -1;
    80000a70:	557d                	li	a0,-1
    80000a72:	a831                	j	80000a8e <copyout+0xb6>
    80000a74:	557d                	li	a0,-1
    80000a76:	6906                	ld	s2,64(sp)
    80000a78:	7a42                	ld	s4,48(sp)
    80000a7a:	6c42                	ld	s8,16(sp)
    80000a7c:	6ca2                	ld	s9,8(sp)
    80000a7e:	6d02                	ld	s10,0(sp)
    80000a80:	a039                	j	80000a8e <copyout+0xb6>
      return -1;
    80000a82:	557d                	li	a0,-1
    80000a84:	6906                	ld	s2,64(sp)
    80000a86:	7a42                	ld	s4,48(sp)
    80000a88:	6c42                	ld	s8,16(sp)
    80000a8a:	6ca2                	ld	s9,8(sp)
    80000a8c:	6d02                	ld	s10,0(sp)
}
    80000a8e:	60e6                	ld	ra,88(sp)
    80000a90:	6446                	ld	s0,80(sp)
    80000a92:	64a6                	ld	s1,72(sp)
    80000a94:	79e2                	ld	s3,56(sp)
    80000a96:	7aa2                	ld	s5,40(sp)
    80000a98:	7b02                	ld	s6,32(sp)
    80000a9a:	6be2                	ld	s7,24(sp)
    80000a9c:	6125                	addi	sp,sp,96
    80000a9e:	8082                	ret
      return -1;
    80000aa0:	557d                	li	a0,-1
    80000aa2:	6906                	ld	s2,64(sp)
    80000aa4:	7a42                	ld	s4,48(sp)
    80000aa6:	6c42                	ld	s8,16(sp)
    80000aa8:	6ca2                	ld	s9,8(sp)
    80000aaa:	6d02                	ld	s10,0(sp)
    80000aac:	b7cd                	j	80000a8e <copyout+0xb6>

0000000080000aae <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000aae:	c6a5                	beqz	a3,80000b16 <copyin+0x68>
{
    80000ab0:	715d                	addi	sp,sp,-80
    80000ab2:	e486                	sd	ra,72(sp)
    80000ab4:	e0a2                	sd	s0,64(sp)
    80000ab6:	fc26                	sd	s1,56(sp)
    80000ab8:	f84a                	sd	s2,48(sp)
    80000aba:	f44e                	sd	s3,40(sp)
    80000abc:	f052                	sd	s4,32(sp)
    80000abe:	ec56                	sd	s5,24(sp)
    80000ac0:	e85a                	sd	s6,16(sp)
    80000ac2:	e45e                	sd	s7,8(sp)
    80000ac4:	e062                	sd	s8,0(sp)
    80000ac6:	0880                	addi	s0,sp,80
    80000ac8:	8b2a                	mv	s6,a0
    80000aca:	8a2e                	mv	s4,a1
    80000acc:	8c32                	mv	s8,a2
    80000ace:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ad0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ad2:	6a85                	lui	s5,0x1
    80000ad4:	a00d                	j	80000af6 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ad6:	018505b3          	add	a1,a0,s8
    80000ada:	0004861b          	sext.w	a2,s1
    80000ade:	412585b3          	sub	a1,a1,s2
    80000ae2:	8552                	mv	a0,s4
    80000ae4:	ec6ff0ef          	jal	800001aa <memmove>

    len -= n;
    80000ae8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000aec:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000aee:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000af2:	02098063          	beqz	s3,80000b12 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000af6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000afa:	85ca                	mv	a1,s2
    80000afc:	855a                	mv	a0,s6
    80000afe:	95fff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000b02:	cd01                	beqz	a0,80000b1a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b04:	418904b3          	sub	s1,s2,s8
    80000b08:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b0a:	fc99f6e3          	bgeu	s3,s1,80000ad6 <copyin+0x28>
    80000b0e:	84ce                	mv	s1,s3
    80000b10:	b7d9                	j	80000ad6 <copyin+0x28>
  }
  return 0;
    80000b12:	4501                	li	a0,0
    80000b14:	a021                	j	80000b1c <copyin+0x6e>
    80000b16:	4501                	li	a0,0
}
    80000b18:	8082                	ret
      return -1;
    80000b1a:	557d                	li	a0,-1
}
    80000b1c:	60a6                	ld	ra,72(sp)
    80000b1e:	6406                	ld	s0,64(sp)
    80000b20:	74e2                	ld	s1,56(sp)
    80000b22:	7942                	ld	s2,48(sp)
    80000b24:	79a2                	ld	s3,40(sp)
    80000b26:	7a02                	ld	s4,32(sp)
    80000b28:	6ae2                	ld	s5,24(sp)
    80000b2a:	6b42                	ld	s6,16(sp)
    80000b2c:	6ba2                	ld	s7,8(sp)
    80000b2e:	6c02                	ld	s8,0(sp)
    80000b30:	6161                	addi	sp,sp,80
    80000b32:	8082                	ret

0000000080000b34 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b34:	c6dd                	beqz	a3,80000be2 <copyinstr+0xae>
{
    80000b36:	715d                	addi	sp,sp,-80
    80000b38:	e486                	sd	ra,72(sp)
    80000b3a:	e0a2                	sd	s0,64(sp)
    80000b3c:	fc26                	sd	s1,56(sp)
    80000b3e:	f84a                	sd	s2,48(sp)
    80000b40:	f44e                	sd	s3,40(sp)
    80000b42:	f052                	sd	s4,32(sp)
    80000b44:	ec56                	sd	s5,24(sp)
    80000b46:	e85a                	sd	s6,16(sp)
    80000b48:	e45e                	sd	s7,8(sp)
    80000b4a:	0880                	addi	s0,sp,80
    80000b4c:	8a2a                	mv	s4,a0
    80000b4e:	8b2e                	mv	s6,a1
    80000b50:	8bb2                	mv	s7,a2
    80000b52:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b54:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b56:	6985                	lui	s3,0x1
    80000b58:	a825                	j	80000b90 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b5a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b5e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b60:	37fd                	addiw	a5,a5,-1
    80000b62:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b66:	60a6                	ld	ra,72(sp)
    80000b68:	6406                	ld	s0,64(sp)
    80000b6a:	74e2                	ld	s1,56(sp)
    80000b6c:	7942                	ld	s2,48(sp)
    80000b6e:	79a2                	ld	s3,40(sp)
    80000b70:	7a02                	ld	s4,32(sp)
    80000b72:	6ae2                	ld	s5,24(sp)
    80000b74:	6b42                	ld	s6,16(sp)
    80000b76:	6ba2                	ld	s7,8(sp)
    80000b78:	6161                	addi	sp,sp,80
    80000b7a:	8082                	ret
    80000b7c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b80:	9742                	add	a4,a4,a6
      --max;
    80000b82:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000b86:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000b8a:	04e58463          	beq	a1,a4,80000bd2 <copyinstr+0x9e>
{
    80000b8e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000b90:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b94:	85a6                	mv	a1,s1
    80000b96:	8552                	mv	a0,s4
    80000b98:	8c5ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000b9c:	cd0d                	beqz	a0,80000bd6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000b9e:	417486b3          	sub	a3,s1,s7
    80000ba2:	96ce                	add	a3,a3,s3
    if(n > max)
    80000ba4:	00d97363          	bgeu	s2,a3,80000baa <copyinstr+0x76>
    80000ba8:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000baa:	955e                	add	a0,a0,s7
    80000bac:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bae:	c695                	beqz	a3,80000bda <copyinstr+0xa6>
    80000bb0:	87da                	mv	a5,s6
    80000bb2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000bb4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bb8:	96da                	add	a3,a3,s6
    80000bba:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bbc:	00f60733          	add	a4,a2,a5
    80000bc0:	00074703          	lbu	a4,0(a4)
    80000bc4:	db59                	beqz	a4,80000b5a <copyinstr+0x26>
        *dst = *p;
    80000bc6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bca:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bcc:	fed797e3          	bne	a5,a3,80000bba <copyinstr+0x86>
    80000bd0:	b775                	j	80000b7c <copyinstr+0x48>
    80000bd2:	4781                	li	a5,0
    80000bd4:	b771                	j	80000b60 <copyinstr+0x2c>
      return -1;
    80000bd6:	557d                	li	a0,-1
    80000bd8:	b779                	j	80000b66 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000bda:	6b85                	lui	s7,0x1
    80000bdc:	9ba6                	add	s7,s7,s1
    80000bde:	87da                	mv	a5,s6
    80000be0:	b77d                	j	80000b8e <copyinstr+0x5a>
  int got_null = 0;
    80000be2:	4781                	li	a5,0
  if(got_null){
    80000be4:	37fd                	addiw	a5,a5,-1
    80000be6:	0007851b          	sext.w	a0,a5
}
    80000bea:	8082                	ret

0000000080000bec <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bec:	7139                	addi	sp,sp,-64
    80000bee:	fc06                	sd	ra,56(sp)
    80000bf0:	f822                	sd	s0,48(sp)
    80000bf2:	f426                	sd	s1,40(sp)
    80000bf4:	f04a                	sd	s2,32(sp)
    80000bf6:	ec4e                	sd	s3,24(sp)
    80000bf8:	e852                	sd	s4,16(sp)
    80000bfa:	e456                	sd	s5,8(sp)
    80000bfc:	e05a                	sd	s6,0(sp)
    80000bfe:	0080                	addi	s0,sp,64
    80000c00:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c02:	00007497          	auipc	s1,0x7
    80000c06:	14e48493          	addi	s1,s1,334 # 80007d50 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c0a:	8b26                	mv	s6,s1
    80000c0c:	04fa5937          	lui	s2,0x4fa5
    80000c10:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c14:	0932                	slli	s2,s2,0xc
    80000c16:	fa590913          	addi	s2,s2,-91
    80000c1a:	0932                	slli	s2,s2,0xc
    80000c1c:	fa590913          	addi	s2,s2,-91
    80000c20:	0932                	slli	s2,s2,0xc
    80000c22:	fa590913          	addi	s2,s2,-91
    80000c26:	040009b7          	lui	s3,0x4000
    80000c2a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c2c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c2e:	0000da97          	auipc	s5,0xd
    80000c32:	b22a8a93          	addi	s5,s5,-1246 # 8000d750 <tickslock>
    char *pa = kalloc();
    80000c36:	cc8ff0ef          	jal	800000fe <kalloc>
    80000c3a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c3c:	cd15                	beqz	a0,80000c78 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c3e:	416485b3          	sub	a1,s1,s6
    80000c42:	858d                	srai	a1,a1,0x3
    80000c44:	032585b3          	mul	a1,a1,s2
    80000c48:	2585                	addiw	a1,a1,1
    80000c4a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c4e:	4719                	li	a4,6
    80000c50:	6685                	lui	a3,0x1
    80000c52:	40b985b3          	sub	a1,s3,a1
    80000c56:	8552                	mv	a0,s4
    80000c58:	8f3ff0ef          	jal	8000054a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c5c:	16848493          	addi	s1,s1,360
    80000c60:	fd549be3          	bne	s1,s5,80000c36 <proc_mapstacks+0x4a>
  }
}
    80000c64:	70e2                	ld	ra,56(sp)
    80000c66:	7442                	ld	s0,48(sp)
    80000c68:	74a2                	ld	s1,40(sp)
    80000c6a:	7902                	ld	s2,32(sp)
    80000c6c:	69e2                	ld	s3,24(sp)
    80000c6e:	6a42                	ld	s4,16(sp)
    80000c70:	6aa2                	ld	s5,8(sp)
    80000c72:	6b02                	ld	s6,0(sp)
    80000c74:	6121                	addi	sp,sp,64
    80000c76:	8082                	ret
      panic("kalloc");
    80000c78:	00006517          	auipc	a0,0x6
    80000c7c:	52050513          	addi	a0,a0,1312 # 80007198 <etext+0x198>
    80000c80:	772040ef          	jal	800053f2 <panic>

0000000080000c84 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c84:	7139                	addi	sp,sp,-64
    80000c86:	fc06                	sd	ra,56(sp)
    80000c88:	f822                	sd	s0,48(sp)
    80000c8a:	f426                	sd	s1,40(sp)
    80000c8c:	f04a                	sd	s2,32(sp)
    80000c8e:	ec4e                	sd	s3,24(sp)
    80000c90:	e852                	sd	s4,16(sp)
    80000c92:	e456                	sd	s5,8(sp)
    80000c94:	e05a                	sd	s6,0(sp)
    80000c96:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c98:	00006597          	auipc	a1,0x6
    80000c9c:	50858593          	addi	a1,a1,1288 # 800071a0 <etext+0x1a0>
    80000ca0:	00007517          	auipc	a0,0x7
    80000ca4:	c8050513          	addi	a0,a0,-896 # 80007920 <pid_lock>
    80000ca8:	1f9040ef          	jal	800056a0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cac:	00006597          	auipc	a1,0x6
    80000cb0:	4fc58593          	addi	a1,a1,1276 # 800071a8 <etext+0x1a8>
    80000cb4:	00007517          	auipc	a0,0x7
    80000cb8:	c8450513          	addi	a0,a0,-892 # 80007938 <wait_lock>
    80000cbc:	1e5040ef          	jal	800056a0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cc0:	00007497          	auipc	s1,0x7
    80000cc4:	09048493          	addi	s1,s1,144 # 80007d50 <proc>
      initlock(&p->lock, "proc");
    80000cc8:	00006b17          	auipc	s6,0x6
    80000ccc:	4f0b0b13          	addi	s6,s6,1264 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cd0:	8aa6                	mv	s5,s1
    80000cd2:	04fa5937          	lui	s2,0x4fa5
    80000cd6:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000cda:	0932                	slli	s2,s2,0xc
    80000cdc:	fa590913          	addi	s2,s2,-91
    80000ce0:	0932                	slli	s2,s2,0xc
    80000ce2:	fa590913          	addi	s2,s2,-91
    80000ce6:	0932                	slli	s2,s2,0xc
    80000ce8:	fa590913          	addi	s2,s2,-91
    80000cec:	040009b7          	lui	s3,0x4000
    80000cf0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000cf2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	0000da17          	auipc	s4,0xd
    80000cf8:	a5ca0a13          	addi	s4,s4,-1444 # 8000d750 <tickslock>
      initlock(&p->lock, "proc");
    80000cfc:	85da                	mv	a1,s6
    80000cfe:	8526                	mv	a0,s1
    80000d00:	1a1040ef          	jal	800056a0 <initlock>
      p->state = UNUSED;
    80000d04:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d08:	415487b3          	sub	a5,s1,s5
    80000d0c:	878d                	srai	a5,a5,0x3
    80000d0e:	032787b3          	mul	a5,a5,s2
    80000d12:	2785                	addiw	a5,a5,1
    80000d14:	00d7979b          	slliw	a5,a5,0xd
    80000d18:	40f987b3          	sub	a5,s3,a5
    80000d1c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d1e:	16848493          	addi	s1,s1,360
    80000d22:	fd449de3          	bne	s1,s4,80000cfc <procinit+0x78>
  }
}
    80000d26:	70e2                	ld	ra,56(sp)
    80000d28:	7442                	ld	s0,48(sp)
    80000d2a:	74a2                	ld	s1,40(sp)
    80000d2c:	7902                	ld	s2,32(sp)
    80000d2e:	69e2                	ld	s3,24(sp)
    80000d30:	6a42                	ld	s4,16(sp)
    80000d32:	6aa2                	ld	s5,8(sp)
    80000d34:	6b02                	ld	s6,0(sp)
    80000d36:	6121                	addi	sp,sp,64
    80000d38:	8082                	ret

0000000080000d3a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d3a:	1141                	addi	sp,sp,-16
    80000d3c:	e422                	sd	s0,8(sp)
    80000d3e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d40:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d42:	2501                	sext.w	a0,a0
    80000d44:	6422                	ld	s0,8(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret

0000000080000d4a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d4a:	1141                	addi	sp,sp,-16
    80000d4c:	e422                	sd	s0,8(sp)
    80000d4e:	0800                	addi	s0,sp,16
    80000d50:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d52:	2781                	sext.w	a5,a5
    80000d54:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d56:	00007517          	auipc	a0,0x7
    80000d5a:	bfa50513          	addi	a0,a0,-1030 # 80007950 <cpus>
    80000d5e:	953e                	add	a0,a0,a5
    80000d60:	6422                	ld	s0,8(sp)
    80000d62:	0141                	addi	sp,sp,16
    80000d64:	8082                	ret

0000000080000d66 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d66:	1101                	addi	sp,sp,-32
    80000d68:	ec06                	sd	ra,24(sp)
    80000d6a:	e822                	sd	s0,16(sp)
    80000d6c:	e426                	sd	s1,8(sp)
    80000d6e:	1000                	addi	s0,sp,32
  push_off();
    80000d70:	171040ef          	jal	800056e0 <push_off>
    80000d74:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d76:	2781                	sext.w	a5,a5
    80000d78:	079e                	slli	a5,a5,0x7
    80000d7a:	00007717          	auipc	a4,0x7
    80000d7e:	ba670713          	addi	a4,a4,-1114 # 80007920 <pid_lock>
    80000d82:	97ba                	add	a5,a5,a4
    80000d84:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d86:	1df040ef          	jal	80005764 <pop_off>
  return p;
}
    80000d8a:	8526                	mv	a0,s1
    80000d8c:	60e2                	ld	ra,24(sp)
    80000d8e:	6442                	ld	s0,16(sp)
    80000d90:	64a2                	ld	s1,8(sp)
    80000d92:	6105                	addi	sp,sp,32
    80000d94:	8082                	ret

0000000080000d96 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d96:	1141                	addi	sp,sp,-16
    80000d98:	e406                	sd	ra,8(sp)
    80000d9a:	e022                	sd	s0,0(sp)
    80000d9c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d9e:	fc9ff0ef          	jal	80000d66 <myproc>
    80000da2:	217040ef          	jal	800057b8 <release>

  if (first) {
    80000da6:	00007797          	auipc	a5,0x7
    80000daa:	ada7a783          	lw	a5,-1318(a5) # 80007880 <first.1>
    80000dae:	e799                	bnez	a5,80000dbc <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000db0:	2bf000ef          	jal	8000186e <usertrapret>
}
    80000db4:	60a2                	ld	ra,8(sp)
    80000db6:	6402                	ld	s0,0(sp)
    80000db8:	0141                	addi	sp,sp,16
    80000dba:	8082                	ret
    fsinit(ROOTDEV);
    80000dbc:	4505                	li	a0,1
    80000dbe:	654010ef          	jal	80002412 <fsinit>
    first = 0;
    80000dc2:	00007797          	auipc	a5,0x7
    80000dc6:	aa07af23          	sw	zero,-1346(a5) # 80007880 <first.1>
    __sync_synchronize();
    80000dca:	0ff0000f          	fence
    80000dce:	b7cd                	j	80000db0 <forkret+0x1a>

0000000080000dd0 <allocpid>:
{
    80000dd0:	1101                	addi	sp,sp,-32
    80000dd2:	ec06                	sd	ra,24(sp)
    80000dd4:	e822                	sd	s0,16(sp)
    80000dd6:	e426                	sd	s1,8(sp)
    80000dd8:	e04a                	sd	s2,0(sp)
    80000dda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ddc:	00007917          	auipc	s2,0x7
    80000de0:	b4490913          	addi	s2,s2,-1212 # 80007920 <pid_lock>
    80000de4:	854a                	mv	a0,s2
    80000de6:	13b040ef          	jal	80005720 <acquire>
  pid = nextpid;
    80000dea:	00007797          	auipc	a5,0x7
    80000dee:	a9a78793          	addi	a5,a5,-1382 # 80007884 <nextpid>
    80000df2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000df4:	0014871b          	addiw	a4,s1,1
    80000df8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dfa:	854a                	mv	a0,s2
    80000dfc:	1bd040ef          	jal	800057b8 <release>
}
    80000e00:	8526                	mv	a0,s1
    80000e02:	60e2                	ld	ra,24(sp)
    80000e04:	6442                	ld	s0,16(sp)
    80000e06:	64a2                	ld	s1,8(sp)
    80000e08:	6902                	ld	s2,0(sp)
    80000e0a:	6105                	addi	sp,sp,32
    80000e0c:	8082                	ret

0000000080000e0e <proc_pagetable>:
{
    80000e0e:	1101                	addi	sp,sp,-32
    80000e10:	ec06                	sd	ra,24(sp)
    80000e12:	e822                	sd	s0,16(sp)
    80000e14:	e426                	sd	s1,8(sp)
    80000e16:	e04a                	sd	s2,0(sp)
    80000e18:	1000                	addi	s0,sp,32
    80000e1a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e1c:	8e1ff0ef          	jal	800006fc <uvmcreate>
    80000e20:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e22:	cd05                	beqz	a0,80000e5a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e24:	4729                	li	a4,10
    80000e26:	00005697          	auipc	a3,0x5
    80000e2a:	1da68693          	addi	a3,a3,474 # 80006000 <_trampoline>
    80000e2e:	6605                	lui	a2,0x1
    80000e30:	040005b7          	lui	a1,0x4000
    80000e34:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e36:	05b2                	slli	a1,a1,0xc
    80000e38:	e62ff0ef          	jal	8000049a <mappages>
    80000e3c:	02054663          	bltz	a0,80000e68 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e40:	4719                	li	a4,6
    80000e42:	05893683          	ld	a3,88(s2)
    80000e46:	6605                	lui	a2,0x1
    80000e48:	020005b7          	lui	a1,0x2000
    80000e4c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e4e:	05b6                	slli	a1,a1,0xd
    80000e50:	8526                	mv	a0,s1
    80000e52:	e48ff0ef          	jal	8000049a <mappages>
    80000e56:	00054f63          	bltz	a0,80000e74 <proc_pagetable+0x66>
}
    80000e5a:	8526                	mv	a0,s1
    80000e5c:	60e2                	ld	ra,24(sp)
    80000e5e:	6442                	ld	s0,16(sp)
    80000e60:	64a2                	ld	s1,8(sp)
    80000e62:	6902                	ld	s2,0(sp)
    80000e64:	6105                	addi	sp,sp,32
    80000e66:	8082                	ret
    uvmfree(pagetable, 0);
    80000e68:	4581                	li	a1,0
    80000e6a:	8526                	mv	a0,s1
    80000e6c:	a5fff0ef          	jal	800008ca <uvmfree>
    return 0;
    80000e70:	4481                	li	s1,0
    80000e72:	b7e5                	j	80000e5a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e74:	4681                	li	a3,0
    80000e76:	4605                	li	a2,1
    80000e78:	040005b7          	lui	a1,0x4000
    80000e7c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e7e:	05b2                	slli	a1,a1,0xc
    80000e80:	8526                	mv	a0,s1
    80000e82:	fbeff0ef          	jal	80000640 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e86:	4581                	li	a1,0
    80000e88:	8526                	mv	a0,s1
    80000e8a:	a41ff0ef          	jal	800008ca <uvmfree>
    return 0;
    80000e8e:	4481                	li	s1,0
    80000e90:	b7e9                	j	80000e5a <proc_pagetable+0x4c>

0000000080000e92 <proc_freepagetable>:
{
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	e04a                	sd	s2,0(sp)
    80000e9c:	1000                	addi	s0,sp,32
    80000e9e:	84aa                	mv	s1,a0
    80000ea0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ea2:	4681                	li	a3,0
    80000ea4:	4605                	li	a2,1
    80000ea6:	040005b7          	lui	a1,0x4000
    80000eaa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eac:	05b2                	slli	a1,a1,0xc
    80000eae:	f92ff0ef          	jal	80000640 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000eb2:	4681                	li	a3,0
    80000eb4:	4605                	li	a2,1
    80000eb6:	020005b7          	lui	a1,0x2000
    80000eba:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ebc:	05b6                	slli	a1,a1,0xd
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	f80ff0ef          	jal	80000640 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ec4:	85ca                	mv	a1,s2
    80000ec6:	8526                	mv	a0,s1
    80000ec8:	a03ff0ef          	jal	800008ca <uvmfree>
}
    80000ecc:	60e2                	ld	ra,24(sp)
    80000ece:	6442                	ld	s0,16(sp)
    80000ed0:	64a2                	ld	s1,8(sp)
    80000ed2:	6902                	ld	s2,0(sp)
    80000ed4:	6105                	addi	sp,sp,32
    80000ed6:	8082                	ret

0000000080000ed8 <freeproc>:
{
    80000ed8:	1101                	addi	sp,sp,-32
    80000eda:	ec06                	sd	ra,24(sp)
    80000edc:	e822                	sd	s0,16(sp)
    80000ede:	e426                	sd	s1,8(sp)
    80000ee0:	1000                	addi	s0,sp,32
    80000ee2:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ee4:	6d28                	ld	a0,88(a0)
    80000ee6:	c119                	beqz	a0,80000eec <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ee8:	934ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000eec:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ef0:	68a8                	ld	a0,80(s1)
    80000ef2:	c501                	beqz	a0,80000efa <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000ef4:	64ac                	ld	a1,72(s1)
    80000ef6:	f9dff0ef          	jal	80000e92 <proc_freepagetable>
  p->pagetable = 0;
    80000efa:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000efe:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f02:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f06:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f0a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f0e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f12:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f16:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f1a:	0004ac23          	sw	zero,24(s1)
}
    80000f1e:	60e2                	ld	ra,24(sp)
    80000f20:	6442                	ld	s0,16(sp)
    80000f22:	64a2                	ld	s1,8(sp)
    80000f24:	6105                	addi	sp,sp,32
    80000f26:	8082                	ret

0000000080000f28 <allocproc>:
{
    80000f28:	1101                	addi	sp,sp,-32
    80000f2a:	ec06                	sd	ra,24(sp)
    80000f2c:	e822                	sd	s0,16(sp)
    80000f2e:	e426                	sd	s1,8(sp)
    80000f30:	e04a                	sd	s2,0(sp)
    80000f32:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f34:	00007497          	auipc	s1,0x7
    80000f38:	e1c48493          	addi	s1,s1,-484 # 80007d50 <proc>
    80000f3c:	0000d917          	auipc	s2,0xd
    80000f40:	81490913          	addi	s2,s2,-2028 # 8000d750 <tickslock>
    acquire(&p->lock);
    80000f44:	8526                	mv	a0,s1
    80000f46:	7da040ef          	jal	80005720 <acquire>
    if(p->state == UNUSED) {
    80000f4a:	4c9c                	lw	a5,24(s1)
    80000f4c:	cb91                	beqz	a5,80000f60 <allocproc+0x38>
      release(&p->lock);
    80000f4e:	8526                	mv	a0,s1
    80000f50:	069040ef          	jal	800057b8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f54:	16848493          	addi	s1,s1,360
    80000f58:	ff2496e3          	bne	s1,s2,80000f44 <allocproc+0x1c>
  return 0;
    80000f5c:	4481                	li	s1,0
    80000f5e:	a089                	j	80000fa0 <allocproc+0x78>
  p->pid = allocpid();
    80000f60:	e71ff0ef          	jal	80000dd0 <allocpid>
    80000f64:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f66:	4785                	li	a5,1
    80000f68:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f6a:	994ff0ef          	jal	800000fe <kalloc>
    80000f6e:	892a                	mv	s2,a0
    80000f70:	eca8                	sd	a0,88(s1)
    80000f72:	cd15                	beqz	a0,80000fae <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f74:	8526                	mv	a0,s1
    80000f76:	e99ff0ef          	jal	80000e0e <proc_pagetable>
    80000f7a:	892a                	mv	s2,a0
    80000f7c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f7e:	c121                	beqz	a0,80000fbe <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f80:	07000613          	li	a2,112
    80000f84:	4581                	li	a1,0
    80000f86:	06048513          	addi	a0,s1,96
    80000f8a:	9c4ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80000f8e:	00000797          	auipc	a5,0x0
    80000f92:	e0878793          	addi	a5,a5,-504 # 80000d96 <forkret>
    80000f96:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f98:	60bc                	ld	a5,64(s1)
    80000f9a:	6705                	lui	a4,0x1
    80000f9c:	97ba                	add	a5,a5,a4
    80000f9e:	f4bc                	sd	a5,104(s1)
}
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	60e2                	ld	ra,24(sp)
    80000fa4:	6442                	ld	s0,16(sp)
    80000fa6:	64a2                	ld	s1,8(sp)
    80000fa8:	6902                	ld	s2,0(sp)
    80000faa:	6105                	addi	sp,sp,32
    80000fac:	8082                	ret
    freeproc(p);
    80000fae:	8526                	mv	a0,s1
    80000fb0:	f29ff0ef          	jal	80000ed8 <freeproc>
    release(&p->lock);
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	003040ef          	jal	800057b8 <release>
    return 0;
    80000fba:	84ca                	mv	s1,s2
    80000fbc:	b7d5                	j	80000fa0 <allocproc+0x78>
    freeproc(p);
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	f19ff0ef          	jal	80000ed8 <freeproc>
    release(&p->lock);
    80000fc4:	8526                	mv	a0,s1
    80000fc6:	7f2040ef          	jal	800057b8 <release>
    return 0;
    80000fca:	84ca                	mv	s1,s2
    80000fcc:	bfd1                	j	80000fa0 <allocproc+0x78>

0000000080000fce <userinit>:
{
    80000fce:	1101                	addi	sp,sp,-32
    80000fd0:	ec06                	sd	ra,24(sp)
    80000fd2:	e822                	sd	s0,16(sp)
    80000fd4:	e426                	sd	s1,8(sp)
    80000fd6:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fd8:	f51ff0ef          	jal	80000f28 <allocproc>
    80000fdc:	84aa                	mv	s1,a0
  initproc = p;
    80000fde:	00007797          	auipc	a5,0x7
    80000fe2:	90a7b123          	sd	a0,-1790(a5) # 800078e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fe6:	03400613          	li	a2,52
    80000fea:	00007597          	auipc	a1,0x7
    80000fee:	8a658593          	addi	a1,a1,-1882 # 80007890 <initcode>
    80000ff2:	6928                	ld	a0,80(a0)
    80000ff4:	f2eff0ef          	jal	80000722 <uvmfirst>
  p->sz = PGSIZE;
    80000ff8:	6785                	lui	a5,0x1
    80000ffa:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000ffc:	6cb8                	ld	a4,88(s1)
    80000ffe:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001002:	6cb8                	ld	a4,88(s1)
    80001004:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001006:	4641                	li	a2,16
    80001008:	00006597          	auipc	a1,0x6
    8000100c:	1b858593          	addi	a1,a1,440 # 800071c0 <etext+0x1c0>
    80001010:	15848513          	addi	a0,s1,344
    80001014:	a78ff0ef          	jal	8000028c <safestrcpy>
  p->cwd = namei("/");
    80001018:	00006517          	auipc	a0,0x6
    8000101c:	1b850513          	addi	a0,a0,440 # 800071d0 <etext+0x1d0>
    80001020:	501010ef          	jal	80002d20 <namei>
    80001024:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001028:	478d                	li	a5,3
    8000102a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000102c:	8526                	mv	a0,s1
    8000102e:	78a040ef          	jal	800057b8 <release>
}
    80001032:	60e2                	ld	ra,24(sp)
    80001034:	6442                	ld	s0,16(sp)
    80001036:	64a2                	ld	s1,8(sp)
    80001038:	6105                	addi	sp,sp,32
    8000103a:	8082                	ret

000000008000103c <growproc>:
{
    8000103c:	1101                	addi	sp,sp,-32
    8000103e:	ec06                	sd	ra,24(sp)
    80001040:	e822                	sd	s0,16(sp)
    80001042:	e426                	sd	s1,8(sp)
    80001044:	e04a                	sd	s2,0(sp)
    80001046:	1000                	addi	s0,sp,32
    80001048:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000104a:	d1dff0ef          	jal	80000d66 <myproc>
    8000104e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001050:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001052:	01204c63          	bgtz	s2,8000106a <growproc+0x2e>
  } else if(n < 0){
    80001056:	02094463          	bltz	s2,8000107e <growproc+0x42>
  p->sz = sz;
    8000105a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000105c:	4501                	li	a0,0
}
    8000105e:	60e2                	ld	ra,24(sp)
    80001060:	6442                	ld	s0,16(sp)
    80001062:	64a2                	ld	s1,8(sp)
    80001064:	6902                	ld	s2,0(sp)
    80001066:	6105                	addi	sp,sp,32
    80001068:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000106a:	4691                	li	a3,4
    8000106c:	00b90633          	add	a2,s2,a1
    80001070:	6928                	ld	a0,80(a0)
    80001072:	f52ff0ef          	jal	800007c4 <uvmalloc>
    80001076:	85aa                	mv	a1,a0
    80001078:	f16d                	bnez	a0,8000105a <growproc+0x1e>
      return -1;
    8000107a:	557d                	li	a0,-1
    8000107c:	b7cd                	j	8000105e <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000107e:	00b90633          	add	a2,s2,a1
    80001082:	6928                	ld	a0,80(a0)
    80001084:	efcff0ef          	jal	80000780 <uvmdealloc>
    80001088:	85aa                	mv	a1,a0
    8000108a:	bfc1                	j	8000105a <growproc+0x1e>

000000008000108c <fork>:
{
    8000108c:	7139                	addi	sp,sp,-64
    8000108e:	fc06                	sd	ra,56(sp)
    80001090:	f822                	sd	s0,48(sp)
    80001092:	f04a                	sd	s2,32(sp)
    80001094:	e456                	sd	s5,8(sp)
    80001096:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001098:	ccfff0ef          	jal	80000d66 <myproc>
    8000109c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000109e:	e8bff0ef          	jal	80000f28 <allocproc>
    800010a2:	0e050a63          	beqz	a0,80001196 <fork+0x10a>
    800010a6:	e852                	sd	s4,16(sp)
    800010a8:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010aa:	048ab603          	ld	a2,72(s5)
    800010ae:	692c                	ld	a1,80(a0)
    800010b0:	050ab503          	ld	a0,80(s5)
    800010b4:	849ff0ef          	jal	800008fc <uvmcopy>
    800010b8:	04054a63          	bltz	a0,8000110c <fork+0x80>
    800010bc:	f426                	sd	s1,40(sp)
    800010be:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010c0:	048ab783          	ld	a5,72(s5)
    800010c4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010c8:	058ab683          	ld	a3,88(s5)
    800010cc:	87b6                	mv	a5,a3
    800010ce:	058a3703          	ld	a4,88(s4)
    800010d2:	12068693          	addi	a3,a3,288
    800010d6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010da:	6788                	ld	a0,8(a5)
    800010dc:	6b8c                	ld	a1,16(a5)
    800010de:	6f90                	ld	a2,24(a5)
    800010e0:	01073023          	sd	a6,0(a4)
    800010e4:	e708                	sd	a0,8(a4)
    800010e6:	eb0c                	sd	a1,16(a4)
    800010e8:	ef10                	sd	a2,24(a4)
    800010ea:	02078793          	addi	a5,a5,32
    800010ee:	02070713          	addi	a4,a4,32
    800010f2:	fed792e3          	bne	a5,a3,800010d6 <fork+0x4a>
  np->trapframe->a0 = 0;
    800010f6:	058a3783          	ld	a5,88(s4)
    800010fa:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010fe:	0d0a8493          	addi	s1,s5,208
    80001102:	0d0a0913          	addi	s2,s4,208
    80001106:	150a8993          	addi	s3,s5,336
    8000110a:	a831                	j	80001126 <fork+0x9a>
    freeproc(np);
    8000110c:	8552                	mv	a0,s4
    8000110e:	dcbff0ef          	jal	80000ed8 <freeproc>
    release(&np->lock);
    80001112:	8552                	mv	a0,s4
    80001114:	6a4040ef          	jal	800057b8 <release>
    return -1;
    80001118:	597d                	li	s2,-1
    8000111a:	6a42                	ld	s4,16(sp)
    8000111c:	a0b5                	j	80001188 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    8000111e:	04a1                	addi	s1,s1,8
    80001120:	0921                	addi	s2,s2,8
    80001122:	01348963          	beq	s1,s3,80001134 <fork+0xa8>
    if(p->ofile[i])
    80001126:	6088                	ld	a0,0(s1)
    80001128:	d97d                	beqz	a0,8000111e <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000112a:	186020ef          	jal	800032b0 <filedup>
    8000112e:	00a93023          	sd	a0,0(s2)
    80001132:	b7f5                	j	8000111e <fork+0x92>
  np->cwd = idup(p->cwd);
    80001134:	150ab503          	ld	a0,336(s5)
    80001138:	4d8010ef          	jal	80002610 <idup>
    8000113c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001140:	4641                	li	a2,16
    80001142:	158a8593          	addi	a1,s5,344
    80001146:	158a0513          	addi	a0,s4,344
    8000114a:	942ff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    8000114e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001152:	8552                	mv	a0,s4
    80001154:	664040ef          	jal	800057b8 <release>
  acquire(&wait_lock);
    80001158:	00006497          	auipc	s1,0x6
    8000115c:	7e048493          	addi	s1,s1,2016 # 80007938 <wait_lock>
    80001160:	8526                	mv	a0,s1
    80001162:	5be040ef          	jal	80005720 <acquire>
  np->parent = p;
    80001166:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000116a:	8526                	mv	a0,s1
    8000116c:	64c040ef          	jal	800057b8 <release>
  acquire(&np->lock);
    80001170:	8552                	mv	a0,s4
    80001172:	5ae040ef          	jal	80005720 <acquire>
  np->state = RUNNABLE;
    80001176:	478d                	li	a5,3
    80001178:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000117c:	8552                	mv	a0,s4
    8000117e:	63a040ef          	jal	800057b8 <release>
  return pid;
    80001182:	74a2                	ld	s1,40(sp)
    80001184:	69e2                	ld	s3,24(sp)
    80001186:	6a42                	ld	s4,16(sp)
}
    80001188:	854a                	mv	a0,s2
    8000118a:	70e2                	ld	ra,56(sp)
    8000118c:	7442                	ld	s0,48(sp)
    8000118e:	7902                	ld	s2,32(sp)
    80001190:	6aa2                	ld	s5,8(sp)
    80001192:	6121                	addi	sp,sp,64
    80001194:	8082                	ret
    return -1;
    80001196:	597d                	li	s2,-1
    80001198:	bfc5                	j	80001188 <fork+0xfc>

000000008000119a <scheduler>:
{
    8000119a:	715d                	addi	sp,sp,-80
    8000119c:	e486                	sd	ra,72(sp)
    8000119e:	e0a2                	sd	s0,64(sp)
    800011a0:	fc26                	sd	s1,56(sp)
    800011a2:	f84a                	sd	s2,48(sp)
    800011a4:	f44e                	sd	s3,40(sp)
    800011a6:	f052                	sd	s4,32(sp)
    800011a8:	ec56                	sd	s5,24(sp)
    800011aa:	e85a                	sd	s6,16(sp)
    800011ac:	e45e                	sd	s7,8(sp)
    800011ae:	e062                	sd	s8,0(sp)
    800011b0:	0880                	addi	s0,sp,80
    800011b2:	8792                	mv	a5,tp
  int id = r_tp();
    800011b4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011b6:	00779b13          	slli	s6,a5,0x7
    800011ba:	00006717          	auipc	a4,0x6
    800011be:	76670713          	addi	a4,a4,1894 # 80007920 <pid_lock>
    800011c2:	975a                	add	a4,a4,s6
    800011c4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c8:	00006717          	auipc	a4,0x6
    800011cc:	79070713          	addi	a4,a4,1936 # 80007958 <cpus+0x8>
    800011d0:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011d2:	4c11                	li	s8,4
        c->proc = p;
    800011d4:	079e                	slli	a5,a5,0x7
    800011d6:	00006a17          	auipc	s4,0x6
    800011da:	74aa0a13          	addi	s4,s4,1866 # 80007920 <pid_lock>
    800011de:	9a3e                	add	s4,s4,a5
        found = 1;
    800011e0:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800011e2:	0000c997          	auipc	s3,0xc
    800011e6:	56e98993          	addi	s3,s3,1390 # 8000d750 <tickslock>
    800011ea:	a0a9                	j	80001234 <scheduler+0x9a>
      release(&p->lock);
    800011ec:	8526                	mv	a0,s1
    800011ee:	5ca040ef          	jal	800057b8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011f2:	16848493          	addi	s1,s1,360
    800011f6:	03348563          	beq	s1,s3,80001220 <scheduler+0x86>
      acquire(&p->lock);
    800011fa:	8526                	mv	a0,s1
    800011fc:	524040ef          	jal	80005720 <acquire>
      if(p->state == RUNNABLE) {
    80001200:	4c9c                	lw	a5,24(s1)
    80001202:	ff2795e3          	bne	a5,s2,800011ec <scheduler+0x52>
        p->state = RUNNING;
    80001206:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000120a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000120e:	06048593          	addi	a1,s1,96
    80001212:	855a                	mv	a0,s6
    80001214:	5b4000ef          	jal	800017c8 <swtch>
        c->proc = 0;
    80001218:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000121c:	8ade                	mv	s5,s7
    8000121e:	b7f9                	j	800011ec <scheduler+0x52>
    if(found == 0) {
    80001220:	000a9a63          	bnez	s5,80001234 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001224:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001228:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000122c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001230:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001234:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001238:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000123c:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001240:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001242:	00007497          	auipc	s1,0x7
    80001246:	b0e48493          	addi	s1,s1,-1266 # 80007d50 <proc>
      if(p->state == RUNNABLE) {
    8000124a:	490d                	li	s2,3
    8000124c:	b77d                	j	800011fa <scheduler+0x60>

000000008000124e <sched>:
{
    8000124e:	7179                	addi	sp,sp,-48
    80001250:	f406                	sd	ra,40(sp)
    80001252:	f022                	sd	s0,32(sp)
    80001254:	ec26                	sd	s1,24(sp)
    80001256:	e84a                	sd	s2,16(sp)
    80001258:	e44e                	sd	s3,8(sp)
    8000125a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000125c:	b0bff0ef          	jal	80000d66 <myproc>
    80001260:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001262:	454040ef          	jal	800056b6 <holding>
    80001266:	c92d                	beqz	a0,800012d8 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001268:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000126a:	2781                	sext.w	a5,a5
    8000126c:	079e                	slli	a5,a5,0x7
    8000126e:	00006717          	auipc	a4,0x6
    80001272:	6b270713          	addi	a4,a4,1714 # 80007920 <pid_lock>
    80001276:	97ba                	add	a5,a5,a4
    80001278:	0a87a703          	lw	a4,168(a5)
    8000127c:	4785                	li	a5,1
    8000127e:	06f71363          	bne	a4,a5,800012e4 <sched+0x96>
  if(p->state == RUNNING)
    80001282:	4c98                	lw	a4,24(s1)
    80001284:	4791                	li	a5,4
    80001286:	06f70563          	beq	a4,a5,800012f0 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000128a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000128e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001290:	e7b5                	bnez	a5,800012fc <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001292:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001294:	00006917          	auipc	s2,0x6
    80001298:	68c90913          	addi	s2,s2,1676 # 80007920 <pid_lock>
    8000129c:	2781                	sext.w	a5,a5
    8000129e:	079e                	slli	a5,a5,0x7
    800012a0:	97ca                	add	a5,a5,s2
    800012a2:	0ac7a983          	lw	s3,172(a5)
    800012a6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012a8:	2781                	sext.w	a5,a5
    800012aa:	079e                	slli	a5,a5,0x7
    800012ac:	00006597          	auipc	a1,0x6
    800012b0:	6ac58593          	addi	a1,a1,1708 # 80007958 <cpus+0x8>
    800012b4:	95be                	add	a1,a1,a5
    800012b6:	06048513          	addi	a0,s1,96
    800012ba:	50e000ef          	jal	800017c8 <swtch>
    800012be:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012c0:	2781                	sext.w	a5,a5
    800012c2:	079e                	slli	a5,a5,0x7
    800012c4:	993e                	add	s2,s2,a5
    800012c6:	0b392623          	sw	s3,172(s2)
}
    800012ca:	70a2                	ld	ra,40(sp)
    800012cc:	7402                	ld	s0,32(sp)
    800012ce:	64e2                	ld	s1,24(sp)
    800012d0:	6942                	ld	s2,16(sp)
    800012d2:	69a2                	ld	s3,8(sp)
    800012d4:	6145                	addi	sp,sp,48
    800012d6:	8082                	ret
    panic("sched p->lock");
    800012d8:	00006517          	auipc	a0,0x6
    800012dc:	f0050513          	addi	a0,a0,-256 # 800071d8 <etext+0x1d8>
    800012e0:	112040ef          	jal	800053f2 <panic>
    panic("sched locks");
    800012e4:	00006517          	auipc	a0,0x6
    800012e8:	f0450513          	addi	a0,a0,-252 # 800071e8 <etext+0x1e8>
    800012ec:	106040ef          	jal	800053f2 <panic>
    panic("sched running");
    800012f0:	00006517          	auipc	a0,0x6
    800012f4:	f0850513          	addi	a0,a0,-248 # 800071f8 <etext+0x1f8>
    800012f8:	0fa040ef          	jal	800053f2 <panic>
    panic("sched interruptible");
    800012fc:	00006517          	auipc	a0,0x6
    80001300:	f0c50513          	addi	a0,a0,-244 # 80007208 <etext+0x208>
    80001304:	0ee040ef          	jal	800053f2 <panic>

0000000080001308 <yield>:
{
    80001308:	1101                	addi	sp,sp,-32
    8000130a:	ec06                	sd	ra,24(sp)
    8000130c:	e822                	sd	s0,16(sp)
    8000130e:	e426                	sd	s1,8(sp)
    80001310:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001312:	a55ff0ef          	jal	80000d66 <myproc>
    80001316:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001318:	408040ef          	jal	80005720 <acquire>
  p->state = RUNNABLE;
    8000131c:	478d                	li	a5,3
    8000131e:	cc9c                	sw	a5,24(s1)
  sched();
    80001320:	f2fff0ef          	jal	8000124e <sched>
  release(&p->lock);
    80001324:	8526                	mv	a0,s1
    80001326:	492040ef          	jal	800057b8 <release>
}
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6105                	addi	sp,sp,32
    80001332:	8082                	ret

0000000080001334 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001334:	7179                	addi	sp,sp,-48
    80001336:	f406                	sd	ra,40(sp)
    80001338:	f022                	sd	s0,32(sp)
    8000133a:	ec26                	sd	s1,24(sp)
    8000133c:	e84a                	sd	s2,16(sp)
    8000133e:	e44e                	sd	s3,8(sp)
    80001340:	1800                	addi	s0,sp,48
    80001342:	89aa                	mv	s3,a0
    80001344:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001346:	a21ff0ef          	jal	80000d66 <myproc>
    8000134a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000134c:	3d4040ef          	jal	80005720 <acquire>
  release(lk);
    80001350:	854a                	mv	a0,s2
    80001352:	466040ef          	jal	800057b8 <release>

  // Go to sleep.
  p->chan = chan;
    80001356:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000135a:	4789                	li	a5,2
    8000135c:	cc9c                	sw	a5,24(s1)

  sched();
    8000135e:	ef1ff0ef          	jal	8000124e <sched>

  // Tidy up.
  p->chan = 0;
    80001362:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001366:	8526                	mv	a0,s1
    80001368:	450040ef          	jal	800057b8 <release>
  acquire(lk);
    8000136c:	854a                	mv	a0,s2
    8000136e:	3b2040ef          	jal	80005720 <acquire>
}
    80001372:	70a2                	ld	ra,40(sp)
    80001374:	7402                	ld	s0,32(sp)
    80001376:	64e2                	ld	s1,24(sp)
    80001378:	6942                	ld	s2,16(sp)
    8000137a:	69a2                	ld	s3,8(sp)
    8000137c:	6145                	addi	sp,sp,48
    8000137e:	8082                	ret

0000000080001380 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001380:	7139                	addi	sp,sp,-64
    80001382:	fc06                	sd	ra,56(sp)
    80001384:	f822                	sd	s0,48(sp)
    80001386:	f426                	sd	s1,40(sp)
    80001388:	f04a                	sd	s2,32(sp)
    8000138a:	ec4e                	sd	s3,24(sp)
    8000138c:	e852                	sd	s4,16(sp)
    8000138e:	e456                	sd	s5,8(sp)
    80001390:	0080                	addi	s0,sp,64
    80001392:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001394:	00007497          	auipc	s1,0x7
    80001398:	9bc48493          	addi	s1,s1,-1604 # 80007d50 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000139c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000139e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013a0:	0000c917          	auipc	s2,0xc
    800013a4:	3b090913          	addi	s2,s2,944 # 8000d750 <tickslock>
    800013a8:	a801                	j	800013b8 <wakeup+0x38>
      }
      release(&p->lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	40c040ef          	jal	800057b8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013b0:	16848493          	addi	s1,s1,360
    800013b4:	03248263          	beq	s1,s2,800013d8 <wakeup+0x58>
    if(p != myproc()){
    800013b8:	9afff0ef          	jal	80000d66 <myproc>
    800013bc:	fea48ae3          	beq	s1,a0,800013b0 <wakeup+0x30>
      acquire(&p->lock);
    800013c0:	8526                	mv	a0,s1
    800013c2:	35e040ef          	jal	80005720 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013c6:	4c9c                	lw	a5,24(s1)
    800013c8:	ff3791e3          	bne	a5,s3,800013aa <wakeup+0x2a>
    800013cc:	709c                	ld	a5,32(s1)
    800013ce:	fd479ee3          	bne	a5,s4,800013aa <wakeup+0x2a>
        p->state = RUNNABLE;
    800013d2:	0154ac23          	sw	s5,24(s1)
    800013d6:	bfd1                	j	800013aa <wakeup+0x2a>
    }
  }
}
    800013d8:	70e2                	ld	ra,56(sp)
    800013da:	7442                	ld	s0,48(sp)
    800013dc:	74a2                	ld	s1,40(sp)
    800013de:	7902                	ld	s2,32(sp)
    800013e0:	69e2                	ld	s3,24(sp)
    800013e2:	6a42                	ld	s4,16(sp)
    800013e4:	6aa2                	ld	s5,8(sp)
    800013e6:	6121                	addi	sp,sp,64
    800013e8:	8082                	ret

00000000800013ea <reparent>:
{
    800013ea:	7179                	addi	sp,sp,-48
    800013ec:	f406                	sd	ra,40(sp)
    800013ee:	f022                	sd	s0,32(sp)
    800013f0:	ec26                	sd	s1,24(sp)
    800013f2:	e84a                	sd	s2,16(sp)
    800013f4:	e44e                	sd	s3,8(sp)
    800013f6:	e052                	sd	s4,0(sp)
    800013f8:	1800                	addi	s0,sp,48
    800013fa:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013fc:	00007497          	auipc	s1,0x7
    80001400:	95448493          	addi	s1,s1,-1708 # 80007d50 <proc>
      pp->parent = initproc;
    80001404:	00006a17          	auipc	s4,0x6
    80001408:	4dca0a13          	addi	s4,s4,1244 # 800078e0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000140c:	0000c997          	auipc	s3,0xc
    80001410:	34498993          	addi	s3,s3,836 # 8000d750 <tickslock>
    80001414:	a029                	j	8000141e <reparent+0x34>
    80001416:	16848493          	addi	s1,s1,360
    8000141a:	01348b63          	beq	s1,s3,80001430 <reparent+0x46>
    if(pp->parent == p){
    8000141e:	7c9c                	ld	a5,56(s1)
    80001420:	ff279be3          	bne	a5,s2,80001416 <reparent+0x2c>
      pp->parent = initproc;
    80001424:	000a3503          	ld	a0,0(s4)
    80001428:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000142a:	f57ff0ef          	jal	80001380 <wakeup>
    8000142e:	b7e5                	j	80001416 <reparent+0x2c>
}
    80001430:	70a2                	ld	ra,40(sp)
    80001432:	7402                	ld	s0,32(sp)
    80001434:	64e2                	ld	s1,24(sp)
    80001436:	6942                	ld	s2,16(sp)
    80001438:	69a2                	ld	s3,8(sp)
    8000143a:	6a02                	ld	s4,0(sp)
    8000143c:	6145                	addi	sp,sp,48
    8000143e:	8082                	ret

0000000080001440 <exit>:
{
    80001440:	7179                	addi	sp,sp,-48
    80001442:	f406                	sd	ra,40(sp)
    80001444:	f022                	sd	s0,32(sp)
    80001446:	ec26                	sd	s1,24(sp)
    80001448:	e84a                	sd	s2,16(sp)
    8000144a:	e44e                	sd	s3,8(sp)
    8000144c:	e052                	sd	s4,0(sp)
    8000144e:	1800                	addi	s0,sp,48
    80001450:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001452:	915ff0ef          	jal	80000d66 <myproc>
    80001456:	89aa                	mv	s3,a0
  if(p == initproc)
    80001458:	00006797          	auipc	a5,0x6
    8000145c:	4887b783          	ld	a5,1160(a5) # 800078e0 <initproc>
    80001460:	0d050493          	addi	s1,a0,208
    80001464:	15050913          	addi	s2,a0,336
    80001468:	00a79f63          	bne	a5,a0,80001486 <exit+0x46>
    panic("init exiting");
    8000146c:	00006517          	auipc	a0,0x6
    80001470:	db450513          	addi	a0,a0,-588 # 80007220 <etext+0x220>
    80001474:	77f030ef          	jal	800053f2 <panic>
      fileclose(f);
    80001478:	67f010ef          	jal	800032f6 <fileclose>
      p->ofile[fd] = 0;
    8000147c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001480:	04a1                	addi	s1,s1,8
    80001482:	01248563          	beq	s1,s2,8000148c <exit+0x4c>
    if(p->ofile[fd]){
    80001486:	6088                	ld	a0,0(s1)
    80001488:	f965                	bnez	a0,80001478 <exit+0x38>
    8000148a:	bfdd                	j	80001480 <exit+0x40>
  begin_op();
    8000148c:	251010ef          	jal	80002edc <begin_op>
  iput(p->cwd);
    80001490:	1509b503          	ld	a0,336(s3)
    80001494:	334010ef          	jal	800027c8 <iput>
  end_op();
    80001498:	2af010ef          	jal	80002f46 <end_op>
  p->cwd = 0;
    8000149c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014a0:	00006497          	auipc	s1,0x6
    800014a4:	49848493          	addi	s1,s1,1176 # 80007938 <wait_lock>
    800014a8:	8526                	mv	a0,s1
    800014aa:	276040ef          	jal	80005720 <acquire>
  reparent(p);
    800014ae:	854e                	mv	a0,s3
    800014b0:	f3bff0ef          	jal	800013ea <reparent>
  wakeup(p->parent);
    800014b4:	0389b503          	ld	a0,56(s3)
    800014b8:	ec9ff0ef          	jal	80001380 <wakeup>
  acquire(&p->lock);
    800014bc:	854e                	mv	a0,s3
    800014be:	262040ef          	jal	80005720 <acquire>
  p->xstate = status;
    800014c2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c6:	4795                	li	a5,5
    800014c8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014cc:	8526                	mv	a0,s1
    800014ce:	2ea040ef          	jal	800057b8 <release>
  sched();
    800014d2:	d7dff0ef          	jal	8000124e <sched>
  panic("zombie exit");
    800014d6:	00006517          	auipc	a0,0x6
    800014da:	d5a50513          	addi	a0,a0,-678 # 80007230 <etext+0x230>
    800014de:	715030ef          	jal	800053f2 <panic>

00000000800014e2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014e2:	7179                	addi	sp,sp,-48
    800014e4:	f406                	sd	ra,40(sp)
    800014e6:	f022                	sd	s0,32(sp)
    800014e8:	ec26                	sd	s1,24(sp)
    800014ea:	e84a                	sd	s2,16(sp)
    800014ec:	e44e                	sd	s3,8(sp)
    800014ee:	1800                	addi	s0,sp,48
    800014f0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014f2:	00007497          	auipc	s1,0x7
    800014f6:	85e48493          	addi	s1,s1,-1954 # 80007d50 <proc>
    800014fa:	0000c997          	auipc	s3,0xc
    800014fe:	25698993          	addi	s3,s3,598 # 8000d750 <tickslock>
    acquire(&p->lock);
    80001502:	8526                	mv	a0,s1
    80001504:	21c040ef          	jal	80005720 <acquire>
    if(p->pid == pid){
    80001508:	589c                	lw	a5,48(s1)
    8000150a:	01278b63          	beq	a5,s2,80001520 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000150e:	8526                	mv	a0,s1
    80001510:	2a8040ef          	jal	800057b8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001514:	16848493          	addi	s1,s1,360
    80001518:	ff3495e3          	bne	s1,s3,80001502 <kill+0x20>
  }
  return -1;
    8000151c:	557d                	li	a0,-1
    8000151e:	a819                	j	80001534 <kill+0x52>
      p->killed = 1;
    80001520:	4785                	li	a5,1
    80001522:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001524:	4c98                	lw	a4,24(s1)
    80001526:	4789                	li	a5,2
    80001528:	00f70d63          	beq	a4,a5,80001542 <kill+0x60>
      release(&p->lock);
    8000152c:	8526                	mv	a0,s1
    8000152e:	28a040ef          	jal	800057b8 <release>
      return 0;
    80001532:	4501                	li	a0,0
}
    80001534:	70a2                	ld	ra,40(sp)
    80001536:	7402                	ld	s0,32(sp)
    80001538:	64e2                	ld	s1,24(sp)
    8000153a:	6942                	ld	s2,16(sp)
    8000153c:	69a2                	ld	s3,8(sp)
    8000153e:	6145                	addi	sp,sp,48
    80001540:	8082                	ret
        p->state = RUNNABLE;
    80001542:	478d                	li	a5,3
    80001544:	cc9c                	sw	a5,24(s1)
    80001546:	b7dd                	j	8000152c <kill+0x4a>

0000000080001548 <setkilled>:

void
setkilled(struct proc *p)
{
    80001548:	1101                	addi	sp,sp,-32
    8000154a:	ec06                	sd	ra,24(sp)
    8000154c:	e822                	sd	s0,16(sp)
    8000154e:	e426                	sd	s1,8(sp)
    80001550:	1000                	addi	s0,sp,32
    80001552:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001554:	1cc040ef          	jal	80005720 <acquire>
  p->killed = 1;
    80001558:	4785                	li	a5,1
    8000155a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000155c:	8526                	mv	a0,s1
    8000155e:	25a040ef          	jal	800057b8 <release>
}
    80001562:	60e2                	ld	ra,24(sp)
    80001564:	6442                	ld	s0,16(sp)
    80001566:	64a2                	ld	s1,8(sp)
    80001568:	6105                	addi	sp,sp,32
    8000156a:	8082                	ret

000000008000156c <killed>:

int
killed(struct proc *p)
{
    8000156c:	1101                	addi	sp,sp,-32
    8000156e:	ec06                	sd	ra,24(sp)
    80001570:	e822                	sd	s0,16(sp)
    80001572:	e426                	sd	s1,8(sp)
    80001574:	e04a                	sd	s2,0(sp)
    80001576:	1000                	addi	s0,sp,32
    80001578:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000157a:	1a6040ef          	jal	80005720 <acquire>
  k = p->killed;
    8000157e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001582:	8526                	mv	a0,s1
    80001584:	234040ef          	jal	800057b8 <release>
  return k;
}
    80001588:	854a                	mv	a0,s2
    8000158a:	60e2                	ld	ra,24(sp)
    8000158c:	6442                	ld	s0,16(sp)
    8000158e:	64a2                	ld	s1,8(sp)
    80001590:	6902                	ld	s2,0(sp)
    80001592:	6105                	addi	sp,sp,32
    80001594:	8082                	ret

0000000080001596 <wait>:
{
    80001596:	715d                	addi	sp,sp,-80
    80001598:	e486                	sd	ra,72(sp)
    8000159a:	e0a2                	sd	s0,64(sp)
    8000159c:	fc26                	sd	s1,56(sp)
    8000159e:	f84a                	sd	s2,48(sp)
    800015a0:	f44e                	sd	s3,40(sp)
    800015a2:	f052                	sd	s4,32(sp)
    800015a4:	ec56                	sd	s5,24(sp)
    800015a6:	e85a                	sd	s6,16(sp)
    800015a8:	e45e                	sd	s7,8(sp)
    800015aa:	e062                	sd	s8,0(sp)
    800015ac:	0880                	addi	s0,sp,80
    800015ae:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015b0:	fb6ff0ef          	jal	80000d66 <myproc>
    800015b4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015b6:	00006517          	auipc	a0,0x6
    800015ba:	38250513          	addi	a0,a0,898 # 80007938 <wait_lock>
    800015be:	162040ef          	jal	80005720 <acquire>
    havekids = 0;
    800015c2:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015c4:	4a15                	li	s4,5
        havekids = 1;
    800015c6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015c8:	0000c997          	auipc	s3,0xc
    800015cc:	18898993          	addi	s3,s3,392 # 8000d750 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015d0:	00006c17          	auipc	s8,0x6
    800015d4:	368c0c13          	addi	s8,s8,872 # 80007938 <wait_lock>
    800015d8:	a871                	j	80001674 <wait+0xde>
          pid = pp->pid;
    800015da:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015de:	000b0c63          	beqz	s6,800015f6 <wait+0x60>
    800015e2:	4691                	li	a3,4
    800015e4:	02c48613          	addi	a2,s1,44
    800015e8:	85da                	mv	a1,s6
    800015ea:	05093503          	ld	a0,80(s2)
    800015ee:	beaff0ef          	jal	800009d8 <copyout>
    800015f2:	02054b63          	bltz	a0,80001628 <wait+0x92>
          freeproc(pp);
    800015f6:	8526                	mv	a0,s1
    800015f8:	8e1ff0ef          	jal	80000ed8 <freeproc>
          release(&pp->lock);
    800015fc:	8526                	mv	a0,s1
    800015fe:	1ba040ef          	jal	800057b8 <release>
          release(&wait_lock);
    80001602:	00006517          	auipc	a0,0x6
    80001606:	33650513          	addi	a0,a0,822 # 80007938 <wait_lock>
    8000160a:	1ae040ef          	jal	800057b8 <release>
}
    8000160e:	854e                	mv	a0,s3
    80001610:	60a6                	ld	ra,72(sp)
    80001612:	6406                	ld	s0,64(sp)
    80001614:	74e2                	ld	s1,56(sp)
    80001616:	7942                	ld	s2,48(sp)
    80001618:	79a2                	ld	s3,40(sp)
    8000161a:	7a02                	ld	s4,32(sp)
    8000161c:	6ae2                	ld	s5,24(sp)
    8000161e:	6b42                	ld	s6,16(sp)
    80001620:	6ba2                	ld	s7,8(sp)
    80001622:	6c02                	ld	s8,0(sp)
    80001624:	6161                	addi	sp,sp,80
    80001626:	8082                	ret
            release(&pp->lock);
    80001628:	8526                	mv	a0,s1
    8000162a:	18e040ef          	jal	800057b8 <release>
            release(&wait_lock);
    8000162e:	00006517          	auipc	a0,0x6
    80001632:	30a50513          	addi	a0,a0,778 # 80007938 <wait_lock>
    80001636:	182040ef          	jal	800057b8 <release>
            return -1;
    8000163a:	59fd                	li	s3,-1
    8000163c:	bfc9                	j	8000160e <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000163e:	16848493          	addi	s1,s1,360
    80001642:	03348063          	beq	s1,s3,80001662 <wait+0xcc>
      if(pp->parent == p){
    80001646:	7c9c                	ld	a5,56(s1)
    80001648:	ff279be3          	bne	a5,s2,8000163e <wait+0xa8>
        acquire(&pp->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	0d2040ef          	jal	80005720 <acquire>
        if(pp->state == ZOMBIE){
    80001652:	4c9c                	lw	a5,24(s1)
    80001654:	f94783e3          	beq	a5,s4,800015da <wait+0x44>
        release(&pp->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	15e040ef          	jal	800057b8 <release>
        havekids = 1;
    8000165e:	8756                	mv	a4,s5
    80001660:	bff9                	j	8000163e <wait+0xa8>
    if(!havekids || killed(p)){
    80001662:	cf19                	beqz	a4,80001680 <wait+0xea>
    80001664:	854a                	mv	a0,s2
    80001666:	f07ff0ef          	jal	8000156c <killed>
    8000166a:	e919                	bnez	a0,80001680 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000166c:	85e2                	mv	a1,s8
    8000166e:	854a                	mv	a0,s2
    80001670:	cc5ff0ef          	jal	80001334 <sleep>
    havekids = 0;
    80001674:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001676:	00006497          	auipc	s1,0x6
    8000167a:	6da48493          	addi	s1,s1,1754 # 80007d50 <proc>
    8000167e:	b7e1                	j	80001646 <wait+0xb0>
      release(&wait_lock);
    80001680:	00006517          	auipc	a0,0x6
    80001684:	2b850513          	addi	a0,a0,696 # 80007938 <wait_lock>
    80001688:	130040ef          	jal	800057b8 <release>
      return -1;
    8000168c:	59fd                	li	s3,-1
    8000168e:	b741                	j	8000160e <wait+0x78>

0000000080001690 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001690:	7179                	addi	sp,sp,-48
    80001692:	f406                	sd	ra,40(sp)
    80001694:	f022                	sd	s0,32(sp)
    80001696:	ec26                	sd	s1,24(sp)
    80001698:	e84a                	sd	s2,16(sp)
    8000169a:	e44e                	sd	s3,8(sp)
    8000169c:	e052                	sd	s4,0(sp)
    8000169e:	1800                	addi	s0,sp,48
    800016a0:	84aa                	mv	s1,a0
    800016a2:	892e                	mv	s2,a1
    800016a4:	89b2                	mv	s3,a2
    800016a6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016a8:	ebeff0ef          	jal	80000d66 <myproc>
  if(user_dst){
    800016ac:	cc99                	beqz	s1,800016ca <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016ae:	86d2                	mv	a3,s4
    800016b0:	864e                	mv	a2,s3
    800016b2:	85ca                	mv	a1,s2
    800016b4:	6928                	ld	a0,80(a0)
    800016b6:	b22ff0ef          	jal	800009d8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016ba:	70a2                	ld	ra,40(sp)
    800016bc:	7402                	ld	s0,32(sp)
    800016be:	64e2                	ld	s1,24(sp)
    800016c0:	6942                	ld	s2,16(sp)
    800016c2:	69a2                	ld	s3,8(sp)
    800016c4:	6a02                	ld	s4,0(sp)
    800016c6:	6145                	addi	sp,sp,48
    800016c8:	8082                	ret
    memmove((char *)dst, src, len);
    800016ca:	000a061b          	sext.w	a2,s4
    800016ce:	85ce                	mv	a1,s3
    800016d0:	854a                	mv	a0,s2
    800016d2:	ad9fe0ef          	jal	800001aa <memmove>
    return 0;
    800016d6:	8526                	mv	a0,s1
    800016d8:	b7cd                	j	800016ba <either_copyout+0x2a>

00000000800016da <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016da:	7179                	addi	sp,sp,-48
    800016dc:	f406                	sd	ra,40(sp)
    800016de:	f022                	sd	s0,32(sp)
    800016e0:	ec26                	sd	s1,24(sp)
    800016e2:	e84a                	sd	s2,16(sp)
    800016e4:	e44e                	sd	s3,8(sp)
    800016e6:	e052                	sd	s4,0(sp)
    800016e8:	1800                	addi	s0,sp,48
    800016ea:	892a                	mv	s2,a0
    800016ec:	84ae                	mv	s1,a1
    800016ee:	89b2                	mv	s3,a2
    800016f0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016f2:	e74ff0ef          	jal	80000d66 <myproc>
  if(user_src){
    800016f6:	cc99                	beqz	s1,80001714 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016f8:	86d2                	mv	a3,s4
    800016fa:	864e                	mv	a2,s3
    800016fc:	85ca                	mv	a1,s2
    800016fe:	6928                	ld	a0,80(a0)
    80001700:	baeff0ef          	jal	80000aae <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001704:	70a2                	ld	ra,40(sp)
    80001706:	7402                	ld	s0,32(sp)
    80001708:	64e2                	ld	s1,24(sp)
    8000170a:	6942                	ld	s2,16(sp)
    8000170c:	69a2                	ld	s3,8(sp)
    8000170e:	6a02                	ld	s4,0(sp)
    80001710:	6145                	addi	sp,sp,48
    80001712:	8082                	ret
    memmove(dst, (char*)src, len);
    80001714:	000a061b          	sext.w	a2,s4
    80001718:	85ce                	mv	a1,s3
    8000171a:	854a                	mv	a0,s2
    8000171c:	a8ffe0ef          	jal	800001aa <memmove>
    return 0;
    80001720:	8526                	mv	a0,s1
    80001722:	b7cd                	j	80001704 <either_copyin+0x2a>

0000000080001724 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001724:	715d                	addi	sp,sp,-80
    80001726:	e486                	sd	ra,72(sp)
    80001728:	e0a2                	sd	s0,64(sp)
    8000172a:	fc26                	sd	s1,56(sp)
    8000172c:	f84a                	sd	s2,48(sp)
    8000172e:	f44e                	sd	s3,40(sp)
    80001730:	f052                	sd	s4,32(sp)
    80001732:	ec56                	sd	s5,24(sp)
    80001734:	e85a                	sd	s6,16(sp)
    80001736:	e45e                	sd	s7,8(sp)
    80001738:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000173a:	00006517          	auipc	a0,0x6
    8000173e:	8de50513          	addi	a0,a0,-1826 # 80007018 <etext+0x18>
    80001742:	1df030ef          	jal	80005120 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001746:	00006497          	auipc	s1,0x6
    8000174a:	76248493          	addi	s1,s1,1890 # 80007ea8 <proc+0x158>
    8000174e:	0000c917          	auipc	s2,0xc
    80001752:	15a90913          	addi	s2,s2,346 # 8000d8a8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001756:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001758:	00006997          	auipc	s3,0x6
    8000175c:	ae898993          	addi	s3,s3,-1304 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001760:	00006a97          	auipc	s5,0x6
    80001764:	ae8a8a93          	addi	s5,s5,-1304 # 80007248 <etext+0x248>
    printf("\n");
    80001768:	00006a17          	auipc	s4,0x6
    8000176c:	8b0a0a13          	addi	s4,s4,-1872 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001770:	00006b97          	auipc	s7,0x6
    80001774:	000b8b93          	mv	s7,s7
    80001778:	a829                	j	80001792 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000177a:	ed86a583          	lw	a1,-296(a3)
    8000177e:	8556                	mv	a0,s5
    80001780:	1a1030ef          	jal	80005120 <printf>
    printf("\n");
    80001784:	8552                	mv	a0,s4
    80001786:	19b030ef          	jal	80005120 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000178a:	16848493          	addi	s1,s1,360
    8000178e:	03248263          	beq	s1,s2,800017b2 <procdump+0x8e>
    if(p->state == UNUSED)
    80001792:	86a6                	mv	a3,s1
    80001794:	ec04a783          	lw	a5,-320(s1)
    80001798:	dbed                	beqz	a5,8000178a <procdump+0x66>
      state = "???";
    8000179a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000179c:	fcfb6fe3          	bltu	s6,a5,8000177a <procdump+0x56>
    800017a0:	02079713          	slli	a4,a5,0x20
    800017a4:	01d75793          	srli	a5,a4,0x1d
    800017a8:	97de                	add	a5,a5,s7
    800017aa:	6390                	ld	a2,0(a5)
    800017ac:	f679                	bnez	a2,8000177a <procdump+0x56>
      state = "???";
    800017ae:	864e                	mv	a2,s3
    800017b0:	b7e9                	j	8000177a <procdump+0x56>
  }
}
    800017b2:	60a6                	ld	ra,72(sp)
    800017b4:	6406                	ld	s0,64(sp)
    800017b6:	74e2                	ld	s1,56(sp)
    800017b8:	7942                	ld	s2,48(sp)
    800017ba:	79a2                	ld	s3,40(sp)
    800017bc:	7a02                	ld	s4,32(sp)
    800017be:	6ae2                	ld	s5,24(sp)
    800017c0:	6b42                	ld	s6,16(sp)
    800017c2:	6ba2                	ld	s7,8(sp)
    800017c4:	6161                	addi	sp,sp,80
    800017c6:	8082                	ret

00000000800017c8 <swtch>:
    800017c8:	00153023          	sd	ra,0(a0)
    800017cc:	00253423          	sd	sp,8(a0)
    800017d0:	e900                	sd	s0,16(a0)
    800017d2:	ed04                	sd	s1,24(a0)
    800017d4:	03253023          	sd	s2,32(a0)
    800017d8:	03353423          	sd	s3,40(a0)
    800017dc:	03453823          	sd	s4,48(a0)
    800017e0:	03553c23          	sd	s5,56(a0)
    800017e4:	05653023          	sd	s6,64(a0)
    800017e8:	05753423          	sd	s7,72(a0)
    800017ec:	05853823          	sd	s8,80(a0)
    800017f0:	05953c23          	sd	s9,88(a0)
    800017f4:	07a53023          	sd	s10,96(a0)
    800017f8:	07b53423          	sd	s11,104(a0)
    800017fc:	0005b083          	ld	ra,0(a1)
    80001800:	0085b103          	ld	sp,8(a1)
    80001804:	6980                	ld	s0,16(a1)
    80001806:	6d84                	ld	s1,24(a1)
    80001808:	0205b903          	ld	s2,32(a1)
    8000180c:	0285b983          	ld	s3,40(a1)
    80001810:	0305ba03          	ld	s4,48(a1)
    80001814:	0385ba83          	ld	s5,56(a1)
    80001818:	0405bb03          	ld	s6,64(a1)
    8000181c:	0485bb83          	ld	s7,72(a1)
    80001820:	0505bc03          	ld	s8,80(a1)
    80001824:	0585bc83          	ld	s9,88(a1)
    80001828:	0605bd03          	ld	s10,96(a1)
    8000182c:	0685bd83          	ld	s11,104(a1)
    80001830:	8082                	ret

0000000080001832 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001832:	1141                	addi	sp,sp,-16
    80001834:	e406                	sd	ra,8(sp)
    80001836:	e022                	sd	s0,0(sp)
    80001838:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000183a:	00006597          	auipc	a1,0x6
    8000183e:	a4e58593          	addi	a1,a1,-1458 # 80007288 <etext+0x288>
    80001842:	0000c517          	auipc	a0,0xc
    80001846:	f0e50513          	addi	a0,a0,-242 # 8000d750 <tickslock>
    8000184a:	657030ef          	jal	800056a0 <initlock>
}
    8000184e:	60a2                	ld	ra,8(sp)
    80001850:	6402                	ld	s0,0(sp)
    80001852:	0141                	addi	sp,sp,16
    80001854:	8082                	ret

0000000080001856 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001856:	1141                	addi	sp,sp,-16
    80001858:	e422                	sd	s0,8(sp)
    8000185a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000185c:	00003797          	auipc	a5,0x3
    80001860:	e0478793          	addi	a5,a5,-508 # 80004660 <kernelvec>
    80001864:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001868:	6422                	ld	s0,8(sp)
    8000186a:	0141                	addi	sp,sp,16
    8000186c:	8082                	ret

000000008000186e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000186e:	1141                	addi	sp,sp,-16
    80001870:	e406                	sd	ra,8(sp)
    80001872:	e022                	sd	s0,0(sp)
    80001874:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001876:	cf0ff0ef          	jal	80000d66 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000187a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000187e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001880:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001884:	00004697          	auipc	a3,0x4
    80001888:	77c68693          	addi	a3,a3,1916 # 80006000 <_trampoline>
    8000188c:	00004717          	auipc	a4,0x4
    80001890:	77470713          	addi	a4,a4,1908 # 80006000 <_trampoline>
    80001894:	8f15                	sub	a4,a4,a3
    80001896:	040007b7          	lui	a5,0x4000
    8000189a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000189c:	07b2                	slli	a5,a5,0xc
    8000189e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018a0:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018a4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018a6:	18002673          	csrr	a2,satp
    800018aa:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018ac:	6d30                	ld	a2,88(a0)
    800018ae:	6138                	ld	a4,64(a0)
    800018b0:	6585                	lui	a1,0x1
    800018b2:	972e                	add	a4,a4,a1
    800018b4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018b6:	6d38                	ld	a4,88(a0)
    800018b8:	00000617          	auipc	a2,0x0
    800018bc:	11060613          	addi	a2,a2,272 # 800019c8 <usertrap>
    800018c0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018c2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018c4:	8612                	mv	a2,tp
    800018c6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018c8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018cc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018d0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018d4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018d8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018da:	6f18                	ld	a4,24(a4)
    800018dc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018e0:	6928                	ld	a0,80(a0)
    800018e2:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018e4:	00004717          	auipc	a4,0x4
    800018e8:	7b870713          	addi	a4,a4,1976 # 8000609c <userret>
    800018ec:	8f15                	sub	a4,a4,a3
    800018ee:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018f0:	577d                	li	a4,-1
    800018f2:	177e                	slli	a4,a4,0x3f
    800018f4:	8d59                	or	a0,a0,a4
    800018f6:	9782                	jalr	a5
}
    800018f8:	60a2                	ld	ra,8(sp)
    800018fa:	6402                	ld	s0,0(sp)
    800018fc:	0141                	addi	sp,sp,16
    800018fe:	8082                	ret

0000000080001900 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001900:	1101                	addi	sp,sp,-32
    80001902:	ec06                	sd	ra,24(sp)
    80001904:	e822                	sd	s0,16(sp)
    80001906:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001908:	c32ff0ef          	jal	80000d3a <cpuid>
    8000190c:	cd11                	beqz	a0,80001928 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000190e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001912:	000f4737          	lui	a4,0xf4
    80001916:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000191a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000191c:	14d79073          	csrw	stimecmp,a5
}
    80001920:	60e2                	ld	ra,24(sp)
    80001922:	6442                	ld	s0,16(sp)
    80001924:	6105                	addi	sp,sp,32
    80001926:	8082                	ret
    80001928:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000192a:	0000c497          	auipc	s1,0xc
    8000192e:	e2648493          	addi	s1,s1,-474 # 8000d750 <tickslock>
    80001932:	8526                	mv	a0,s1
    80001934:	5ed030ef          	jal	80005720 <acquire>
    ticks++;
    80001938:	00006517          	auipc	a0,0x6
    8000193c:	fb050513          	addi	a0,a0,-80 # 800078e8 <ticks>
    80001940:	411c                	lw	a5,0(a0)
    80001942:	2785                	addiw	a5,a5,1
    80001944:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001946:	a3bff0ef          	jal	80001380 <wakeup>
    release(&tickslock);
    8000194a:	8526                	mv	a0,s1
    8000194c:	66d030ef          	jal	800057b8 <release>
    80001950:	64a2                	ld	s1,8(sp)
    80001952:	bf75                	j	8000190e <clockintr+0xe>

0000000080001954 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001954:	1101                	addi	sp,sp,-32
    80001956:	ec06                	sd	ra,24(sp)
    80001958:	e822                	sd	s0,16(sp)
    8000195a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000195c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001960:	57fd                	li	a5,-1
    80001962:	17fe                	slli	a5,a5,0x3f
    80001964:	07a5                	addi	a5,a5,9
    80001966:	00f70c63          	beq	a4,a5,8000197e <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000196a:	57fd                	li	a5,-1
    8000196c:	17fe                	slli	a5,a5,0x3f
    8000196e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001970:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001972:	04f70763          	beq	a4,a5,800019c0 <devintr+0x6c>
  }
}
    80001976:	60e2                	ld	ra,24(sp)
    80001978:	6442                	ld	s0,16(sp)
    8000197a:	6105                	addi	sp,sp,32
    8000197c:	8082                	ret
    8000197e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001980:	58d020ef          	jal	8000470c <plic_claim>
    80001984:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001986:	47a9                	li	a5,10
    80001988:	00f50963          	beq	a0,a5,8000199a <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8000198c:	4785                	li	a5,1
    8000198e:	00f50963          	beq	a0,a5,800019a0 <devintr+0x4c>
    return 1;
    80001992:	4505                	li	a0,1
    } else if(irq){
    80001994:	e889                	bnez	s1,800019a6 <devintr+0x52>
    80001996:	64a2                	ld	s1,8(sp)
    80001998:	bff9                	j	80001976 <devintr+0x22>
      uartintr();
    8000199a:	4cb030ef          	jal	80005664 <uartintr>
    if(irq)
    8000199e:	a819                	j	800019b4 <devintr+0x60>
      virtio_disk_intr();
    800019a0:	232030ef          	jal	80004bd2 <virtio_disk_intr>
    if(irq)
    800019a4:	a801                	j	800019b4 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019a6:	85a6                	mv	a1,s1
    800019a8:	00006517          	auipc	a0,0x6
    800019ac:	8e850513          	addi	a0,a0,-1816 # 80007290 <etext+0x290>
    800019b0:	770030ef          	jal	80005120 <printf>
      plic_complete(irq);
    800019b4:	8526                	mv	a0,s1
    800019b6:	577020ef          	jal	8000472c <plic_complete>
    return 1;
    800019ba:	4505                	li	a0,1
    800019bc:	64a2                	ld	s1,8(sp)
    800019be:	bf65                	j	80001976 <devintr+0x22>
    clockintr();
    800019c0:	f41ff0ef          	jal	80001900 <clockintr>
    return 2;
    800019c4:	4509                	li	a0,2
    800019c6:	bf45                	j	80001976 <devintr+0x22>

00000000800019c8 <usertrap>:
{
    800019c8:	1101                	addi	sp,sp,-32
    800019ca:	ec06                	sd	ra,24(sp)
    800019cc:	e822                	sd	s0,16(sp)
    800019ce:	e426                	sd	s1,8(sp)
    800019d0:	e04a                	sd	s2,0(sp)
    800019d2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019d4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019d8:	1007f793          	andi	a5,a5,256
    800019dc:	ef85                	bnez	a5,80001a14 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019de:	00003797          	auipc	a5,0x3
    800019e2:	c8278793          	addi	a5,a5,-894 # 80004660 <kernelvec>
    800019e6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019ea:	b7cff0ef          	jal	80000d66 <myproc>
    800019ee:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019f0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019f2:	14102773          	csrr	a4,sepc
    800019f6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019f8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019fc:	47a1                	li	a5,8
    800019fe:	02f70163          	beq	a4,a5,80001a20 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a02:	f53ff0ef          	jal	80001954 <devintr>
    80001a06:	892a                	mv	s2,a0
    80001a08:	c135                	beqz	a0,80001a6c <usertrap+0xa4>
  if(killed(p))
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	b61ff0ef          	jal	8000156c <killed>
    80001a10:	cd1d                	beqz	a0,80001a4e <usertrap+0x86>
    80001a12:	a81d                	j	80001a48 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a14:	00006517          	auipc	a0,0x6
    80001a18:	89c50513          	addi	a0,a0,-1892 # 800072b0 <etext+0x2b0>
    80001a1c:	1d7030ef          	jal	800053f2 <panic>
    if(killed(p))
    80001a20:	b4dff0ef          	jal	8000156c <killed>
    80001a24:	e121                	bnez	a0,80001a64 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a26:	6cb8                	ld	a4,88(s1)
    80001a28:	6f1c                	ld	a5,24(a4)
    80001a2a:	0791                	addi	a5,a5,4
    80001a2c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a2e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a32:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a36:	10079073          	csrw	sstatus,a5
    syscall();
    80001a3a:	248000ef          	jal	80001c82 <syscall>
  if(killed(p))
    80001a3e:	8526                	mv	a0,s1
    80001a40:	b2dff0ef          	jal	8000156c <killed>
    80001a44:	c901                	beqz	a0,80001a54 <usertrap+0x8c>
    80001a46:	4901                	li	s2,0
    exit(-1);
    80001a48:	557d                	li	a0,-1
    80001a4a:	9f7ff0ef          	jal	80001440 <exit>
  if(which_dev == 2)
    80001a4e:	4789                	li	a5,2
    80001a50:	04f90563          	beq	s2,a5,80001a9a <usertrap+0xd2>
  usertrapret();
    80001a54:	e1bff0ef          	jal	8000186e <usertrapret>
}
    80001a58:	60e2                	ld	ra,24(sp)
    80001a5a:	6442                	ld	s0,16(sp)
    80001a5c:	64a2                	ld	s1,8(sp)
    80001a5e:	6902                	ld	s2,0(sp)
    80001a60:	6105                	addi	sp,sp,32
    80001a62:	8082                	ret
      exit(-1);
    80001a64:	557d                	li	a0,-1
    80001a66:	9dbff0ef          	jal	80001440 <exit>
    80001a6a:	bf75                	j	80001a26 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a6c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a70:	5890                	lw	a2,48(s1)
    80001a72:	00006517          	auipc	a0,0x6
    80001a76:	85e50513          	addi	a0,a0,-1954 # 800072d0 <etext+0x2d0>
    80001a7a:	6a6030ef          	jal	80005120 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a82:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a86:	00006517          	auipc	a0,0x6
    80001a8a:	87a50513          	addi	a0,a0,-1926 # 80007300 <etext+0x300>
    80001a8e:	692030ef          	jal	80005120 <printf>
    setkilled(p);
    80001a92:	8526                	mv	a0,s1
    80001a94:	ab5ff0ef          	jal	80001548 <setkilled>
    80001a98:	b75d                	j	80001a3e <usertrap+0x76>
    yield();
    80001a9a:	86fff0ef          	jal	80001308 <yield>
    80001a9e:	bf5d                	j	80001a54 <usertrap+0x8c>

0000000080001aa0 <kerneltrap>:
{
    80001aa0:	7179                	addi	sp,sp,-48
    80001aa2:	f406                	sd	ra,40(sp)
    80001aa4:	f022                	sd	s0,32(sp)
    80001aa6:	ec26                	sd	s1,24(sp)
    80001aa8:	e84a                	sd	s2,16(sp)
    80001aaa:	e44e                	sd	s3,8(sp)
    80001aac:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aae:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ab6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001aba:	1004f793          	andi	a5,s1,256
    80001abe:	c795                	beqz	a5,80001aea <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ac4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ac6:	eb85                	bnez	a5,80001af6 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001ac8:	e8dff0ef          	jal	80001954 <devintr>
    80001acc:	c91d                	beqz	a0,80001b02 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001ace:	4789                	li	a5,2
    80001ad0:	04f50a63          	beq	a0,a5,80001b24 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ad4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad8:	10049073          	csrw	sstatus,s1
}
    80001adc:	70a2                	ld	ra,40(sp)
    80001ade:	7402                	ld	s0,32(sp)
    80001ae0:	64e2                	ld	s1,24(sp)
    80001ae2:	6942                	ld	s2,16(sp)
    80001ae4:	69a2                	ld	s3,8(sp)
    80001ae6:	6145                	addi	sp,sp,48
    80001ae8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001aea:	00006517          	auipc	a0,0x6
    80001aee:	83e50513          	addi	a0,a0,-1986 # 80007328 <etext+0x328>
    80001af2:	101030ef          	jal	800053f2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001af6:	00006517          	auipc	a0,0x6
    80001afa:	85a50513          	addi	a0,a0,-1958 # 80007350 <etext+0x350>
    80001afe:	0f5030ef          	jal	800053f2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b02:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b06:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b0a:	85ce                	mv	a1,s3
    80001b0c:	00006517          	auipc	a0,0x6
    80001b10:	86450513          	addi	a0,a0,-1948 # 80007370 <etext+0x370>
    80001b14:	60c030ef          	jal	80005120 <printf>
    panic("kerneltrap");
    80001b18:	00006517          	auipc	a0,0x6
    80001b1c:	88050513          	addi	a0,a0,-1920 # 80007398 <etext+0x398>
    80001b20:	0d3030ef          	jal	800053f2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b24:	a42ff0ef          	jal	80000d66 <myproc>
    80001b28:	d555                	beqz	a0,80001ad4 <kerneltrap+0x34>
    yield();
    80001b2a:	fdeff0ef          	jal	80001308 <yield>
    80001b2e:	b75d                	j	80001ad4 <kerneltrap+0x34>

0000000080001b30 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b30:	1101                	addi	sp,sp,-32
    80001b32:	ec06                	sd	ra,24(sp)
    80001b34:	e822                	sd	s0,16(sp)
    80001b36:	e426                	sd	s1,8(sp)
    80001b38:	1000                	addi	s0,sp,32
    80001b3a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b3c:	a2aff0ef          	jal	80000d66 <myproc>
  switch (n) {
    80001b40:	4795                	li	a5,5
    80001b42:	0497e163          	bltu	a5,s1,80001b84 <argraw+0x54>
    80001b46:	048a                	slli	s1,s1,0x2
    80001b48:	00006717          	auipc	a4,0x6
    80001b4c:	c5870713          	addi	a4,a4,-936 # 800077a0 <states.0+0x30>
    80001b50:	94ba                	add	s1,s1,a4
    80001b52:	409c                	lw	a5,0(s1)
    80001b54:	97ba                	add	a5,a5,a4
    80001b56:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b58:	6d3c                	ld	a5,88(a0)
    80001b5a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b5c:	60e2                	ld	ra,24(sp)
    80001b5e:	6442                	ld	s0,16(sp)
    80001b60:	64a2                	ld	s1,8(sp)
    80001b62:	6105                	addi	sp,sp,32
    80001b64:	8082                	ret
    return p->trapframe->a1;
    80001b66:	6d3c                	ld	a5,88(a0)
    80001b68:	7fa8                	ld	a0,120(a5)
    80001b6a:	bfcd                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a2;
    80001b6c:	6d3c                	ld	a5,88(a0)
    80001b6e:	63c8                	ld	a0,128(a5)
    80001b70:	b7f5                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a3;
    80001b72:	6d3c                	ld	a5,88(a0)
    80001b74:	67c8                	ld	a0,136(a5)
    80001b76:	b7dd                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a4;
    80001b78:	6d3c                	ld	a5,88(a0)
    80001b7a:	6bc8                	ld	a0,144(a5)
    80001b7c:	b7c5                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a5;
    80001b7e:	6d3c                	ld	a5,88(a0)
    80001b80:	6fc8                	ld	a0,152(a5)
    80001b82:	bfe9                	j	80001b5c <argraw+0x2c>
  panic("argraw");
    80001b84:	00006517          	auipc	a0,0x6
    80001b88:	82450513          	addi	a0,a0,-2012 # 800073a8 <etext+0x3a8>
    80001b8c:	067030ef          	jal	800053f2 <panic>

0000000080001b90 <fetchaddr>:
{
    80001b90:	1101                	addi	sp,sp,-32
    80001b92:	ec06                	sd	ra,24(sp)
    80001b94:	e822                	sd	s0,16(sp)
    80001b96:	e426                	sd	s1,8(sp)
    80001b98:	e04a                	sd	s2,0(sp)
    80001b9a:	1000                	addi	s0,sp,32
    80001b9c:	84aa                	mv	s1,a0
    80001b9e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ba0:	9c6ff0ef          	jal	80000d66 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ba4:	653c                	ld	a5,72(a0)
    80001ba6:	02f4f663          	bgeu	s1,a5,80001bd2 <fetchaddr+0x42>
    80001baa:	00848713          	addi	a4,s1,8
    80001bae:	02e7e463          	bltu	a5,a4,80001bd6 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001bb2:	46a1                	li	a3,8
    80001bb4:	8626                	mv	a2,s1
    80001bb6:	85ca                	mv	a1,s2
    80001bb8:	6928                	ld	a0,80(a0)
    80001bba:	ef5fe0ef          	jal	80000aae <copyin>
    80001bbe:	00a03533          	snez	a0,a0
    80001bc2:	40a00533          	neg	a0,a0
}
    80001bc6:	60e2                	ld	ra,24(sp)
    80001bc8:	6442                	ld	s0,16(sp)
    80001bca:	64a2                	ld	s1,8(sp)
    80001bcc:	6902                	ld	s2,0(sp)
    80001bce:	6105                	addi	sp,sp,32
    80001bd0:	8082                	ret
    return -1;
    80001bd2:	557d                	li	a0,-1
    80001bd4:	bfcd                	j	80001bc6 <fetchaddr+0x36>
    80001bd6:	557d                	li	a0,-1
    80001bd8:	b7fd                	j	80001bc6 <fetchaddr+0x36>

0000000080001bda <fetchstr>:
{
    80001bda:	7179                	addi	sp,sp,-48
    80001bdc:	f406                	sd	ra,40(sp)
    80001bde:	f022                	sd	s0,32(sp)
    80001be0:	ec26                	sd	s1,24(sp)
    80001be2:	e84a                	sd	s2,16(sp)
    80001be4:	e44e                	sd	s3,8(sp)
    80001be6:	1800                	addi	s0,sp,48
    80001be8:	892a                	mv	s2,a0
    80001bea:	84ae                	mv	s1,a1
    80001bec:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001bee:	978ff0ef          	jal	80000d66 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001bf2:	86ce                	mv	a3,s3
    80001bf4:	864a                	mv	a2,s2
    80001bf6:	85a6                	mv	a1,s1
    80001bf8:	6928                	ld	a0,80(a0)
    80001bfa:	f3bfe0ef          	jal	80000b34 <copyinstr>
    80001bfe:	00054c63          	bltz	a0,80001c16 <fetchstr+0x3c>
  return strlen(buf);
    80001c02:	8526                	mv	a0,s1
    80001c04:	ebafe0ef          	jal	800002be <strlen>
}
    80001c08:	70a2                	ld	ra,40(sp)
    80001c0a:	7402                	ld	s0,32(sp)
    80001c0c:	64e2                	ld	s1,24(sp)
    80001c0e:	6942                	ld	s2,16(sp)
    80001c10:	69a2                	ld	s3,8(sp)
    80001c12:	6145                	addi	sp,sp,48
    80001c14:	8082                	ret
    return -1;
    80001c16:	557d                	li	a0,-1
    80001c18:	bfc5                	j	80001c08 <fetchstr+0x2e>

0000000080001c1a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c1a:	1101                	addi	sp,sp,-32
    80001c1c:	ec06                	sd	ra,24(sp)
    80001c1e:	e822                	sd	s0,16(sp)
    80001c20:	e426                	sd	s1,8(sp)
    80001c22:	1000                	addi	s0,sp,32
    80001c24:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c26:	f0bff0ef          	jal	80001b30 <argraw>
    80001c2a:	c088                	sw	a0,0(s1)
}
    80001c2c:	60e2                	ld	ra,24(sp)
    80001c2e:	6442                	ld	s0,16(sp)
    80001c30:	64a2                	ld	s1,8(sp)
    80001c32:	6105                	addi	sp,sp,32
    80001c34:	8082                	ret

0000000080001c36 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c36:	1101                	addi	sp,sp,-32
    80001c38:	ec06                	sd	ra,24(sp)
    80001c3a:	e822                	sd	s0,16(sp)
    80001c3c:	e426                	sd	s1,8(sp)
    80001c3e:	1000                	addi	s0,sp,32
    80001c40:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c42:	eefff0ef          	jal	80001b30 <argraw>
    80001c46:	e088                	sd	a0,0(s1)
}
    80001c48:	60e2                	ld	ra,24(sp)
    80001c4a:	6442                	ld	s0,16(sp)
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	6105                	addi	sp,sp,32
    80001c50:	8082                	ret

0000000080001c52 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c52:	7179                	addi	sp,sp,-48
    80001c54:	f406                	sd	ra,40(sp)
    80001c56:	f022                	sd	s0,32(sp)
    80001c58:	ec26                	sd	s1,24(sp)
    80001c5a:	e84a                	sd	s2,16(sp)
    80001c5c:	1800                	addi	s0,sp,48
    80001c5e:	84ae                	mv	s1,a1
    80001c60:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001c62:	fd840593          	addi	a1,s0,-40
    80001c66:	fd1ff0ef          	jal	80001c36 <argaddr>
  return fetchstr(addr, buf, max);
    80001c6a:	864a                	mv	a2,s2
    80001c6c:	85a6                	mv	a1,s1
    80001c6e:	fd843503          	ld	a0,-40(s0)
    80001c72:	f69ff0ef          	jal	80001bda <fetchstr>
}
    80001c76:	70a2                	ld	ra,40(sp)
    80001c78:	7402                	ld	s0,32(sp)
    80001c7a:	64e2                	ld	s1,24(sp)
    80001c7c:	6942                	ld	s2,16(sp)
    80001c7e:	6145                	addi	sp,sp,48
    80001c80:	8082                	ret

0000000080001c82 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001c82:	1101                	addi	sp,sp,-32
    80001c84:	ec06                	sd	ra,24(sp)
    80001c86:	e822                	sd	s0,16(sp)
    80001c88:	e426                	sd	s1,8(sp)
    80001c8a:	e04a                	sd	s2,0(sp)
    80001c8c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c8e:	8d8ff0ef          	jal	80000d66 <myproc>
    80001c92:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c94:	05853903          	ld	s2,88(a0)
    80001c98:	0a893783          	ld	a5,168(s2)
    80001c9c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001ca0:	37fd                	addiw	a5,a5,-1
    80001ca2:	4751                	li	a4,20
    80001ca4:	00f76f63          	bltu	a4,a5,80001cc2 <syscall+0x40>
    80001ca8:	00369713          	slli	a4,a3,0x3
    80001cac:	00006797          	auipc	a5,0x6
    80001cb0:	b0c78793          	addi	a5,a5,-1268 # 800077b8 <syscalls>
    80001cb4:	97ba                	add	a5,a5,a4
    80001cb6:	639c                	ld	a5,0(a5)
    80001cb8:	c789                	beqz	a5,80001cc2 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001cba:	9782                	jalr	a5
    80001cbc:	06a93823          	sd	a0,112(s2)
    80001cc0:	a829                	j	80001cda <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001cc2:	15848613          	addi	a2,s1,344
    80001cc6:	588c                	lw	a1,48(s1)
    80001cc8:	00005517          	auipc	a0,0x5
    80001ccc:	6e850513          	addi	a0,a0,1768 # 800073b0 <etext+0x3b0>
    80001cd0:	450030ef          	jal	80005120 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cd4:	6cbc                	ld	a5,88(s1)
    80001cd6:	577d                	li	a4,-1
    80001cd8:	fbb8                	sd	a4,112(a5)
  }
}
    80001cda:	60e2                	ld	ra,24(sp)
    80001cdc:	6442                	ld	s0,16(sp)
    80001cde:	64a2                	ld	s1,8(sp)
    80001ce0:	6902                	ld	s2,0(sp)
    80001ce2:	6105                	addi	sp,sp,32
    80001ce4:	8082                	ret

0000000080001ce6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001ce6:	1101                	addi	sp,sp,-32
    80001ce8:	ec06                	sd	ra,24(sp)
    80001cea:	e822                	sd	s0,16(sp)
    80001cec:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001cee:	fec40593          	addi	a1,s0,-20
    80001cf2:	4501                	li	a0,0
    80001cf4:	f27ff0ef          	jal	80001c1a <argint>
  exit(n);
    80001cf8:	fec42503          	lw	a0,-20(s0)
    80001cfc:	f44ff0ef          	jal	80001440 <exit>
  return 0;  // not reached
}
    80001d00:	4501                	li	a0,0
    80001d02:	60e2                	ld	ra,24(sp)
    80001d04:	6442                	ld	s0,16(sp)
    80001d06:	6105                	addi	sp,sp,32
    80001d08:	8082                	ret

0000000080001d0a <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d0a:	1141                	addi	sp,sp,-16
    80001d0c:	e406                	sd	ra,8(sp)
    80001d0e:	e022                	sd	s0,0(sp)
    80001d10:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d12:	854ff0ef          	jal	80000d66 <myproc>
}
    80001d16:	5908                	lw	a0,48(a0)
    80001d18:	60a2                	ld	ra,8(sp)
    80001d1a:	6402                	ld	s0,0(sp)
    80001d1c:	0141                	addi	sp,sp,16
    80001d1e:	8082                	ret

0000000080001d20 <sys_fork>:

uint64
sys_fork(void)
{
    80001d20:	1141                	addi	sp,sp,-16
    80001d22:	e406                	sd	ra,8(sp)
    80001d24:	e022                	sd	s0,0(sp)
    80001d26:	0800                	addi	s0,sp,16
  return fork();
    80001d28:	b64ff0ef          	jal	8000108c <fork>
}
    80001d2c:	60a2                	ld	ra,8(sp)
    80001d2e:	6402                	ld	s0,0(sp)
    80001d30:	0141                	addi	sp,sp,16
    80001d32:	8082                	ret

0000000080001d34 <sys_wait>:

uint64
sys_wait(void)
{
    80001d34:	1101                	addi	sp,sp,-32
    80001d36:	ec06                	sd	ra,24(sp)
    80001d38:	e822                	sd	s0,16(sp)
    80001d3a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d3c:	fe840593          	addi	a1,s0,-24
    80001d40:	4501                	li	a0,0
    80001d42:	ef5ff0ef          	jal	80001c36 <argaddr>
  return wait(p);
    80001d46:	fe843503          	ld	a0,-24(s0)
    80001d4a:	84dff0ef          	jal	80001596 <wait>
}
    80001d4e:	60e2                	ld	ra,24(sp)
    80001d50:	6442                	ld	s0,16(sp)
    80001d52:	6105                	addi	sp,sp,32
    80001d54:	8082                	ret

0000000080001d56 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d56:	7179                	addi	sp,sp,-48
    80001d58:	f406                	sd	ra,40(sp)
    80001d5a:	f022                	sd	s0,32(sp)
    80001d5c:	ec26                	sd	s1,24(sp)
    80001d5e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d60:	fdc40593          	addi	a1,s0,-36
    80001d64:	4501                	li	a0,0
    80001d66:	eb5ff0ef          	jal	80001c1a <argint>
  addr = myproc()->sz;
    80001d6a:	ffdfe0ef          	jal	80000d66 <myproc>
    80001d6e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d70:	fdc42503          	lw	a0,-36(s0)
    80001d74:	ac8ff0ef          	jal	8000103c <growproc>
    80001d78:	00054863          	bltz	a0,80001d88 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d7c:	8526                	mv	a0,s1
    80001d7e:	70a2                	ld	ra,40(sp)
    80001d80:	7402                	ld	s0,32(sp)
    80001d82:	64e2                	ld	s1,24(sp)
    80001d84:	6145                	addi	sp,sp,48
    80001d86:	8082                	ret
    return -1;
    80001d88:	54fd                	li	s1,-1
    80001d8a:	bfcd                	j	80001d7c <sys_sbrk+0x26>

0000000080001d8c <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d8c:	7139                	addi	sp,sp,-64
    80001d8e:	fc06                	sd	ra,56(sp)
    80001d90:	f822                	sd	s0,48(sp)
    80001d92:	f04a                	sd	s2,32(sp)
    80001d94:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d96:	fcc40593          	addi	a1,s0,-52
    80001d9a:	4501                	li	a0,0
    80001d9c:	e7fff0ef          	jal	80001c1a <argint>
  if(n < 0)
    80001da0:	fcc42783          	lw	a5,-52(s0)
    80001da4:	0607c763          	bltz	a5,80001e12 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001da8:	0000c517          	auipc	a0,0xc
    80001dac:	9a850513          	addi	a0,a0,-1624 # 8000d750 <tickslock>
    80001db0:	171030ef          	jal	80005720 <acquire>
  ticks0 = ticks;
    80001db4:	00006917          	auipc	s2,0x6
    80001db8:	b3492903          	lw	s2,-1228(s2) # 800078e8 <ticks>
  while(ticks - ticks0 < n){
    80001dbc:	fcc42783          	lw	a5,-52(s0)
    80001dc0:	cf8d                	beqz	a5,80001dfa <sys_sleep+0x6e>
    80001dc2:	f426                	sd	s1,40(sp)
    80001dc4:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001dc6:	0000c997          	auipc	s3,0xc
    80001dca:	98a98993          	addi	s3,s3,-1654 # 8000d750 <tickslock>
    80001dce:	00006497          	auipc	s1,0x6
    80001dd2:	b1a48493          	addi	s1,s1,-1254 # 800078e8 <ticks>
    if(killed(myproc())){
    80001dd6:	f91fe0ef          	jal	80000d66 <myproc>
    80001dda:	f92ff0ef          	jal	8000156c <killed>
    80001dde:	ed0d                	bnez	a0,80001e18 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001de0:	85ce                	mv	a1,s3
    80001de2:	8526                	mv	a0,s1
    80001de4:	d50ff0ef          	jal	80001334 <sleep>
  while(ticks - ticks0 < n){
    80001de8:	409c                	lw	a5,0(s1)
    80001dea:	412787bb          	subw	a5,a5,s2
    80001dee:	fcc42703          	lw	a4,-52(s0)
    80001df2:	fee7e2e3          	bltu	a5,a4,80001dd6 <sys_sleep+0x4a>
    80001df6:	74a2                	ld	s1,40(sp)
    80001df8:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001dfa:	0000c517          	auipc	a0,0xc
    80001dfe:	95650513          	addi	a0,a0,-1706 # 8000d750 <tickslock>
    80001e02:	1b7030ef          	jal	800057b8 <release>
  return 0;
    80001e06:	4501                	li	a0,0
}
    80001e08:	70e2                	ld	ra,56(sp)
    80001e0a:	7442                	ld	s0,48(sp)
    80001e0c:	7902                	ld	s2,32(sp)
    80001e0e:	6121                	addi	sp,sp,64
    80001e10:	8082                	ret
    n = 0;
    80001e12:	fc042623          	sw	zero,-52(s0)
    80001e16:	bf49                	j	80001da8 <sys_sleep+0x1c>
      release(&tickslock);
    80001e18:	0000c517          	auipc	a0,0xc
    80001e1c:	93850513          	addi	a0,a0,-1736 # 8000d750 <tickslock>
    80001e20:	199030ef          	jal	800057b8 <release>
      return -1;
    80001e24:	557d                	li	a0,-1
    80001e26:	74a2                	ld	s1,40(sp)
    80001e28:	69e2                	ld	s3,24(sp)
    80001e2a:	bff9                	j	80001e08 <sys_sleep+0x7c>

0000000080001e2c <sys_kill>:

uint64
sys_kill(void)
{
    80001e2c:	1101                	addi	sp,sp,-32
    80001e2e:	ec06                	sd	ra,24(sp)
    80001e30:	e822                	sd	s0,16(sp)
    80001e32:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e34:	fec40593          	addi	a1,s0,-20
    80001e38:	4501                	li	a0,0
    80001e3a:	de1ff0ef          	jal	80001c1a <argint>
  return kill(pid);
    80001e3e:	fec42503          	lw	a0,-20(s0)
    80001e42:	ea0ff0ef          	jal	800014e2 <kill>
}
    80001e46:	60e2                	ld	ra,24(sp)
    80001e48:	6442                	ld	s0,16(sp)
    80001e4a:	6105                	addi	sp,sp,32
    80001e4c:	8082                	ret

0000000080001e4e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e4e:	1101                	addi	sp,sp,-32
    80001e50:	ec06                	sd	ra,24(sp)
    80001e52:	e822                	sd	s0,16(sp)
    80001e54:	e426                	sd	s1,8(sp)
    80001e56:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e58:	0000c517          	auipc	a0,0xc
    80001e5c:	8f850513          	addi	a0,a0,-1800 # 8000d750 <tickslock>
    80001e60:	0c1030ef          	jal	80005720 <acquire>
  xticks = ticks;
    80001e64:	00006497          	auipc	s1,0x6
    80001e68:	a844a483          	lw	s1,-1404(s1) # 800078e8 <ticks>
  release(&tickslock);
    80001e6c:	0000c517          	auipc	a0,0xc
    80001e70:	8e450513          	addi	a0,a0,-1820 # 8000d750 <tickslock>
    80001e74:	145030ef          	jal	800057b8 <release>
  return xticks;
}
    80001e78:	02049513          	slli	a0,s1,0x20
    80001e7c:	9101                	srli	a0,a0,0x20
    80001e7e:	60e2                	ld	ra,24(sp)
    80001e80:	6442                	ld	s0,16(sp)
    80001e82:	64a2                	ld	s1,8(sp)
    80001e84:	6105                	addi	sp,sp,32
    80001e86:	8082                	ret

0000000080001e88 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001e88:	7179                	addi	sp,sp,-48
    80001e8a:	f406                	sd	ra,40(sp)
    80001e8c:	f022                	sd	s0,32(sp)
    80001e8e:	ec26                	sd	s1,24(sp)
    80001e90:	e84a                	sd	s2,16(sp)
    80001e92:	e44e                	sd	s3,8(sp)
    80001e94:	e052                	sd	s4,0(sp)
    80001e96:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001e98:	00005597          	auipc	a1,0x5
    80001e9c:	53858593          	addi	a1,a1,1336 # 800073d0 <etext+0x3d0>
    80001ea0:	0000c517          	auipc	a0,0xc
    80001ea4:	8c850513          	addi	a0,a0,-1848 # 8000d768 <bcache>
    80001ea8:	7f8030ef          	jal	800056a0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001eac:	00014797          	auipc	a5,0x14
    80001eb0:	8bc78793          	addi	a5,a5,-1860 # 80015768 <bcache+0x8000>
    80001eb4:	00014717          	auipc	a4,0x14
    80001eb8:	b1c70713          	addi	a4,a4,-1252 # 800159d0 <bcache+0x8268>
    80001ebc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001ec0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ec4:	0000c497          	auipc	s1,0xc
    80001ec8:	8bc48493          	addi	s1,s1,-1860 # 8000d780 <bcache+0x18>
    b->next = bcache.head.next;
    80001ecc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001ece:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001ed0:	00005a17          	auipc	s4,0x5
    80001ed4:	508a0a13          	addi	s4,s4,1288 # 800073d8 <etext+0x3d8>
    b->next = bcache.head.next;
    80001ed8:	2b893783          	ld	a5,696(s2)
    80001edc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001ede:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ee2:	85d2                	mv	a1,s4
    80001ee4:	01048513          	addi	a0,s1,16
    80001ee8:	248010ef          	jal	80003130 <initsleeplock>
    bcache.head.next->prev = b;
    80001eec:	2b893783          	ld	a5,696(s2)
    80001ef0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001ef2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ef6:	45848493          	addi	s1,s1,1112
    80001efa:	fd349fe3          	bne	s1,s3,80001ed8 <binit+0x50>
  }
}
    80001efe:	70a2                	ld	ra,40(sp)
    80001f00:	7402                	ld	s0,32(sp)
    80001f02:	64e2                	ld	s1,24(sp)
    80001f04:	6942                	ld	s2,16(sp)
    80001f06:	69a2                	ld	s3,8(sp)
    80001f08:	6a02                	ld	s4,0(sp)
    80001f0a:	6145                	addi	sp,sp,48
    80001f0c:	8082                	ret

0000000080001f0e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001f0e:	7179                	addi	sp,sp,-48
    80001f10:	f406                	sd	ra,40(sp)
    80001f12:	f022                	sd	s0,32(sp)
    80001f14:	ec26                	sd	s1,24(sp)
    80001f16:	e84a                	sd	s2,16(sp)
    80001f18:	e44e                	sd	s3,8(sp)
    80001f1a:	1800                	addi	s0,sp,48
    80001f1c:	892a                	mv	s2,a0
    80001f1e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001f20:	0000c517          	auipc	a0,0xc
    80001f24:	84850513          	addi	a0,a0,-1976 # 8000d768 <bcache>
    80001f28:	7f8030ef          	jal	80005720 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001f2c:	00014497          	auipc	s1,0x14
    80001f30:	af44b483          	ld	s1,-1292(s1) # 80015a20 <bcache+0x82b8>
    80001f34:	00014797          	auipc	a5,0x14
    80001f38:	a9c78793          	addi	a5,a5,-1380 # 800159d0 <bcache+0x8268>
    80001f3c:	02f48b63          	beq	s1,a5,80001f72 <bread+0x64>
    80001f40:	873e                	mv	a4,a5
    80001f42:	a021                	j	80001f4a <bread+0x3c>
    80001f44:	68a4                	ld	s1,80(s1)
    80001f46:	02e48663          	beq	s1,a4,80001f72 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001f4a:	449c                	lw	a5,8(s1)
    80001f4c:	ff279ce3          	bne	a5,s2,80001f44 <bread+0x36>
    80001f50:	44dc                	lw	a5,12(s1)
    80001f52:	ff3799e3          	bne	a5,s3,80001f44 <bread+0x36>
      b->refcnt++;
    80001f56:	40bc                	lw	a5,64(s1)
    80001f58:	2785                	addiw	a5,a5,1
    80001f5a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f5c:	0000c517          	auipc	a0,0xc
    80001f60:	80c50513          	addi	a0,a0,-2036 # 8000d768 <bcache>
    80001f64:	055030ef          	jal	800057b8 <release>
      acquiresleep(&b->lock);
    80001f68:	01048513          	addi	a0,s1,16
    80001f6c:	1fa010ef          	jal	80003166 <acquiresleep>
      return b;
    80001f70:	a889                	j	80001fc2 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f72:	00014497          	auipc	s1,0x14
    80001f76:	aa64b483          	ld	s1,-1370(s1) # 80015a18 <bcache+0x82b0>
    80001f7a:	00014797          	auipc	a5,0x14
    80001f7e:	a5678793          	addi	a5,a5,-1450 # 800159d0 <bcache+0x8268>
    80001f82:	00f48863          	beq	s1,a5,80001f92 <bread+0x84>
    80001f86:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001f88:	40bc                	lw	a5,64(s1)
    80001f8a:	cb91                	beqz	a5,80001f9e <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f8c:	64a4                	ld	s1,72(s1)
    80001f8e:	fee49de3          	bne	s1,a4,80001f88 <bread+0x7a>
  panic("bget: no buffers");
    80001f92:	00005517          	auipc	a0,0x5
    80001f96:	44e50513          	addi	a0,a0,1102 # 800073e0 <etext+0x3e0>
    80001f9a:	458030ef          	jal	800053f2 <panic>
      b->dev = dev;
    80001f9e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80001fa2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80001fa6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001faa:	4785                	li	a5,1
    80001fac:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001fae:	0000b517          	auipc	a0,0xb
    80001fb2:	7ba50513          	addi	a0,a0,1978 # 8000d768 <bcache>
    80001fb6:	003030ef          	jal	800057b8 <release>
      acquiresleep(&b->lock);
    80001fba:	01048513          	addi	a0,s1,16
    80001fbe:	1a8010ef          	jal	80003166 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001fc2:	409c                	lw	a5,0(s1)
    80001fc4:	cb89                	beqz	a5,80001fd6 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001fc6:	8526                	mv	a0,s1
    80001fc8:	70a2                	ld	ra,40(sp)
    80001fca:	7402                	ld	s0,32(sp)
    80001fcc:	64e2                	ld	s1,24(sp)
    80001fce:	6942                	ld	s2,16(sp)
    80001fd0:	69a2                	ld	s3,8(sp)
    80001fd2:	6145                	addi	sp,sp,48
    80001fd4:	8082                	ret
    virtio_disk_rw(b, 0);
    80001fd6:	4581                	li	a1,0
    80001fd8:	8526                	mv	a0,s1
    80001fda:	1e7020ef          	jal	800049c0 <virtio_disk_rw>
    b->valid = 1;
    80001fde:	4785                	li	a5,1
    80001fe0:	c09c                	sw	a5,0(s1)
  return b;
    80001fe2:	b7d5                	j	80001fc6 <bread+0xb8>

0000000080001fe4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80001fe4:	1101                	addi	sp,sp,-32
    80001fe6:	ec06                	sd	ra,24(sp)
    80001fe8:	e822                	sd	s0,16(sp)
    80001fea:	e426                	sd	s1,8(sp)
    80001fec:	1000                	addi	s0,sp,32
    80001fee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001ff0:	0541                	addi	a0,a0,16
    80001ff2:	1f2010ef          	jal	800031e4 <holdingsleep>
    80001ff6:	c911                	beqz	a0,8000200a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80001ff8:	4585                	li	a1,1
    80001ffa:	8526                	mv	a0,s1
    80001ffc:	1c5020ef          	jal	800049c0 <virtio_disk_rw>
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6105                	addi	sp,sp,32
    80002008:	8082                	ret
    panic("bwrite");
    8000200a:	00005517          	auipc	a0,0x5
    8000200e:	3ee50513          	addi	a0,a0,1006 # 800073f8 <etext+0x3f8>
    80002012:	3e0030ef          	jal	800053f2 <panic>

0000000080002016 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	e426                	sd	s1,8(sp)
    8000201e:	e04a                	sd	s2,0(sp)
    80002020:	1000                	addi	s0,sp,32
    80002022:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002024:	01050913          	addi	s2,a0,16
    80002028:	854a                	mv	a0,s2
    8000202a:	1ba010ef          	jal	800031e4 <holdingsleep>
    8000202e:	c135                	beqz	a0,80002092 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002030:	854a                	mv	a0,s2
    80002032:	17a010ef          	jal	800031ac <releasesleep>

  acquire(&bcache.lock);
    80002036:	0000b517          	auipc	a0,0xb
    8000203a:	73250513          	addi	a0,a0,1842 # 8000d768 <bcache>
    8000203e:	6e2030ef          	jal	80005720 <acquire>
  b->refcnt--;
    80002042:	40bc                	lw	a5,64(s1)
    80002044:	37fd                	addiw	a5,a5,-1
    80002046:	0007871b          	sext.w	a4,a5
    8000204a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000204c:	e71d                	bnez	a4,8000207a <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000204e:	68b8                	ld	a4,80(s1)
    80002050:	64bc                	ld	a5,72(s1)
    80002052:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002054:	68b8                	ld	a4,80(s1)
    80002056:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002058:	00013797          	auipc	a5,0x13
    8000205c:	71078793          	addi	a5,a5,1808 # 80015768 <bcache+0x8000>
    80002060:	2b87b703          	ld	a4,696(a5)
    80002064:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002066:	00014717          	auipc	a4,0x14
    8000206a:	96a70713          	addi	a4,a4,-1686 # 800159d0 <bcache+0x8268>
    8000206e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002070:	2b87b703          	ld	a4,696(a5)
    80002074:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002076:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000207a:	0000b517          	auipc	a0,0xb
    8000207e:	6ee50513          	addi	a0,a0,1774 # 8000d768 <bcache>
    80002082:	736030ef          	jal	800057b8 <release>
}
    80002086:	60e2                	ld	ra,24(sp)
    80002088:	6442                	ld	s0,16(sp)
    8000208a:	64a2                	ld	s1,8(sp)
    8000208c:	6902                	ld	s2,0(sp)
    8000208e:	6105                	addi	sp,sp,32
    80002090:	8082                	ret
    panic("brelse");
    80002092:	00005517          	auipc	a0,0x5
    80002096:	36e50513          	addi	a0,a0,878 # 80007400 <etext+0x400>
    8000209a:	358030ef          	jal	800053f2 <panic>

000000008000209e <bpin>:

void
bpin(struct buf *b) {
    8000209e:	1101                	addi	sp,sp,-32
    800020a0:	ec06                	sd	ra,24(sp)
    800020a2:	e822                	sd	s0,16(sp)
    800020a4:	e426                	sd	s1,8(sp)
    800020a6:	1000                	addi	s0,sp,32
    800020a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020aa:	0000b517          	auipc	a0,0xb
    800020ae:	6be50513          	addi	a0,a0,1726 # 8000d768 <bcache>
    800020b2:	66e030ef          	jal	80005720 <acquire>
  b->refcnt++;
    800020b6:	40bc                	lw	a5,64(s1)
    800020b8:	2785                	addiw	a5,a5,1
    800020ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020bc:	0000b517          	auipc	a0,0xb
    800020c0:	6ac50513          	addi	a0,a0,1708 # 8000d768 <bcache>
    800020c4:	6f4030ef          	jal	800057b8 <release>
}
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	64a2                	ld	s1,8(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret

00000000800020d2 <bunpin>:

void
bunpin(struct buf *b) {
    800020d2:	1101                	addi	sp,sp,-32
    800020d4:	ec06                	sd	ra,24(sp)
    800020d6:	e822                	sd	s0,16(sp)
    800020d8:	e426                	sd	s1,8(sp)
    800020da:	1000                	addi	s0,sp,32
    800020dc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020de:	0000b517          	auipc	a0,0xb
    800020e2:	68a50513          	addi	a0,a0,1674 # 8000d768 <bcache>
    800020e6:	63a030ef          	jal	80005720 <acquire>
  b->refcnt--;
    800020ea:	40bc                	lw	a5,64(s1)
    800020ec:	37fd                	addiw	a5,a5,-1
    800020ee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020f0:	0000b517          	auipc	a0,0xb
    800020f4:	67850513          	addi	a0,a0,1656 # 8000d768 <bcache>
    800020f8:	6c0030ef          	jal	800057b8 <release>
}
    800020fc:	60e2                	ld	ra,24(sp)
    800020fe:	6442                	ld	s0,16(sp)
    80002100:	64a2                	ld	s1,8(sp)
    80002102:	6105                	addi	sp,sp,32
    80002104:	8082                	ret

0000000080002106 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002106:	1101                	addi	sp,sp,-32
    80002108:	ec06                	sd	ra,24(sp)
    8000210a:	e822                	sd	s0,16(sp)
    8000210c:	e426                	sd	s1,8(sp)
    8000210e:	e04a                	sd	s2,0(sp)
    80002110:	1000                	addi	s0,sp,32
    80002112:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002114:	00d5d59b          	srliw	a1,a1,0xd
    80002118:	00014797          	auipc	a5,0x14
    8000211c:	d2c7a783          	lw	a5,-724(a5) # 80015e44 <sb+0x1c>
    80002120:	9dbd                	addw	a1,a1,a5
    80002122:	dedff0ef          	jal	80001f0e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002126:	0074f713          	andi	a4,s1,7
    8000212a:	4785                	li	a5,1
    8000212c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002130:	14ce                	slli	s1,s1,0x33
    80002132:	90d9                	srli	s1,s1,0x36
    80002134:	00950733          	add	a4,a0,s1
    80002138:	05874703          	lbu	a4,88(a4)
    8000213c:	00e7f6b3          	and	a3,a5,a4
    80002140:	c29d                	beqz	a3,80002166 <bfree+0x60>
    80002142:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002144:	94aa                	add	s1,s1,a0
    80002146:	fff7c793          	not	a5,a5
    8000214a:	8f7d                	and	a4,a4,a5
    8000214c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002150:	711000ef          	jal	80003060 <log_write>
  brelse(bp);
    80002154:	854a                	mv	a0,s2
    80002156:	ec1ff0ef          	jal	80002016 <brelse>
}
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	64a2                	ld	s1,8(sp)
    80002160:	6902                	ld	s2,0(sp)
    80002162:	6105                	addi	sp,sp,32
    80002164:	8082                	ret
    panic("freeing free block");
    80002166:	00005517          	auipc	a0,0x5
    8000216a:	2a250513          	addi	a0,a0,674 # 80007408 <etext+0x408>
    8000216e:	284030ef          	jal	800053f2 <panic>

0000000080002172 <balloc>:
{
    80002172:	711d                	addi	sp,sp,-96
    80002174:	ec86                	sd	ra,88(sp)
    80002176:	e8a2                	sd	s0,80(sp)
    80002178:	e4a6                	sd	s1,72(sp)
    8000217a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000217c:	00014797          	auipc	a5,0x14
    80002180:	cb07a783          	lw	a5,-848(a5) # 80015e2c <sb+0x4>
    80002184:	0e078f63          	beqz	a5,80002282 <balloc+0x110>
    80002188:	e0ca                	sd	s2,64(sp)
    8000218a:	fc4e                	sd	s3,56(sp)
    8000218c:	f852                	sd	s4,48(sp)
    8000218e:	f456                	sd	s5,40(sp)
    80002190:	f05a                	sd	s6,32(sp)
    80002192:	ec5e                	sd	s7,24(sp)
    80002194:	e862                	sd	s8,16(sp)
    80002196:	e466                	sd	s9,8(sp)
    80002198:	8baa                	mv	s7,a0
    8000219a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000219c:	00014b17          	auipc	s6,0x14
    800021a0:	c8cb0b13          	addi	s6,s6,-884 # 80015e28 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800021a4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800021a6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800021a8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800021aa:	6c89                	lui	s9,0x2
    800021ac:	a0b5                	j	80002218 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800021ae:	97ca                	add	a5,a5,s2
    800021b0:	8e55                	or	a2,a2,a3
    800021b2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800021b6:	854a                	mv	a0,s2
    800021b8:	6a9000ef          	jal	80003060 <log_write>
        brelse(bp);
    800021bc:	854a                	mv	a0,s2
    800021be:	e59ff0ef          	jal	80002016 <brelse>
  bp = bread(dev, bno);
    800021c2:	85a6                	mv	a1,s1
    800021c4:	855e                	mv	a0,s7
    800021c6:	d49ff0ef          	jal	80001f0e <bread>
    800021ca:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800021cc:	40000613          	li	a2,1024
    800021d0:	4581                	li	a1,0
    800021d2:	05850513          	addi	a0,a0,88
    800021d6:	f79fd0ef          	jal	8000014e <memset>
  log_write(bp);
    800021da:	854a                	mv	a0,s2
    800021dc:	685000ef          	jal	80003060 <log_write>
  brelse(bp);
    800021e0:	854a                	mv	a0,s2
    800021e2:	e35ff0ef          	jal	80002016 <brelse>
}
    800021e6:	6906                	ld	s2,64(sp)
    800021e8:	79e2                	ld	s3,56(sp)
    800021ea:	7a42                	ld	s4,48(sp)
    800021ec:	7aa2                	ld	s5,40(sp)
    800021ee:	7b02                	ld	s6,32(sp)
    800021f0:	6be2                	ld	s7,24(sp)
    800021f2:	6c42                	ld	s8,16(sp)
    800021f4:	6ca2                	ld	s9,8(sp)
}
    800021f6:	8526                	mv	a0,s1
    800021f8:	60e6                	ld	ra,88(sp)
    800021fa:	6446                	ld	s0,80(sp)
    800021fc:	64a6                	ld	s1,72(sp)
    800021fe:	6125                	addi	sp,sp,96
    80002200:	8082                	ret
    brelse(bp);
    80002202:	854a                	mv	a0,s2
    80002204:	e13ff0ef          	jal	80002016 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002208:	015c87bb          	addw	a5,s9,s5
    8000220c:	00078a9b          	sext.w	s5,a5
    80002210:	004b2703          	lw	a4,4(s6)
    80002214:	04eaff63          	bgeu	s5,a4,80002272 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002218:	41fad79b          	sraiw	a5,s5,0x1f
    8000221c:	0137d79b          	srliw	a5,a5,0x13
    80002220:	015787bb          	addw	a5,a5,s5
    80002224:	40d7d79b          	sraiw	a5,a5,0xd
    80002228:	01cb2583          	lw	a1,28(s6)
    8000222c:	9dbd                	addw	a1,a1,a5
    8000222e:	855e                	mv	a0,s7
    80002230:	cdfff0ef          	jal	80001f0e <bread>
    80002234:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002236:	004b2503          	lw	a0,4(s6)
    8000223a:	000a849b          	sext.w	s1,s5
    8000223e:	8762                	mv	a4,s8
    80002240:	fca4f1e3          	bgeu	s1,a0,80002202 <balloc+0x90>
      m = 1 << (bi % 8);
    80002244:	00777693          	andi	a3,a4,7
    80002248:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000224c:	41f7579b          	sraiw	a5,a4,0x1f
    80002250:	01d7d79b          	srliw	a5,a5,0x1d
    80002254:	9fb9                	addw	a5,a5,a4
    80002256:	4037d79b          	sraiw	a5,a5,0x3
    8000225a:	00f90633          	add	a2,s2,a5
    8000225e:	05864603          	lbu	a2,88(a2)
    80002262:	00c6f5b3          	and	a1,a3,a2
    80002266:	d5a1                	beqz	a1,800021ae <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002268:	2705                	addiw	a4,a4,1
    8000226a:	2485                	addiw	s1,s1,1
    8000226c:	fd471ae3          	bne	a4,s4,80002240 <balloc+0xce>
    80002270:	bf49                	j	80002202 <balloc+0x90>
    80002272:	6906                	ld	s2,64(sp)
    80002274:	79e2                	ld	s3,56(sp)
    80002276:	7a42                	ld	s4,48(sp)
    80002278:	7aa2                	ld	s5,40(sp)
    8000227a:	7b02                	ld	s6,32(sp)
    8000227c:	6be2                	ld	s7,24(sp)
    8000227e:	6c42                	ld	s8,16(sp)
    80002280:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002282:	00005517          	auipc	a0,0x5
    80002286:	19e50513          	addi	a0,a0,414 # 80007420 <etext+0x420>
    8000228a:	697020ef          	jal	80005120 <printf>
  return 0;
    8000228e:	4481                	li	s1,0
    80002290:	b79d                	j	800021f6 <balloc+0x84>

0000000080002292 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002292:	7179                	addi	sp,sp,-48
    80002294:	f406                	sd	ra,40(sp)
    80002296:	f022                	sd	s0,32(sp)
    80002298:	ec26                	sd	s1,24(sp)
    8000229a:	e84a                	sd	s2,16(sp)
    8000229c:	e44e                	sd	s3,8(sp)
    8000229e:	1800                	addi	s0,sp,48
    800022a0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800022a2:	47ad                	li	a5,11
    800022a4:	02b7e663          	bltu	a5,a1,800022d0 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800022a8:	02059793          	slli	a5,a1,0x20
    800022ac:	01e7d593          	srli	a1,a5,0x1e
    800022b0:	00b504b3          	add	s1,a0,a1
    800022b4:	0504a903          	lw	s2,80(s1)
    800022b8:	06091a63          	bnez	s2,8000232c <bmap+0x9a>
      addr = balloc(ip->dev);
    800022bc:	4108                	lw	a0,0(a0)
    800022be:	eb5ff0ef          	jal	80002172 <balloc>
    800022c2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800022c6:	06090363          	beqz	s2,8000232c <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800022ca:	0524a823          	sw	s2,80(s1)
    800022ce:	a8b9                	j	8000232c <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800022d0:	ff45849b          	addiw	s1,a1,-12
    800022d4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800022d8:	0ff00793          	li	a5,255
    800022dc:	06e7ee63          	bltu	a5,a4,80002358 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800022e0:	08052903          	lw	s2,128(a0)
    800022e4:	00091d63          	bnez	s2,800022fe <bmap+0x6c>
      addr = balloc(ip->dev);
    800022e8:	4108                	lw	a0,0(a0)
    800022ea:	e89ff0ef          	jal	80002172 <balloc>
    800022ee:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800022f2:	02090d63          	beqz	s2,8000232c <bmap+0x9a>
    800022f6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800022f8:	0929a023          	sw	s2,128(s3)
    800022fc:	a011                	j	80002300 <bmap+0x6e>
    800022fe:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002300:	85ca                	mv	a1,s2
    80002302:	0009a503          	lw	a0,0(s3)
    80002306:	c09ff0ef          	jal	80001f0e <bread>
    8000230a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000230c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002310:	02049713          	slli	a4,s1,0x20
    80002314:	01e75593          	srli	a1,a4,0x1e
    80002318:	00b784b3          	add	s1,a5,a1
    8000231c:	0004a903          	lw	s2,0(s1)
    80002320:	00090e63          	beqz	s2,8000233c <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002324:	8552                	mv	a0,s4
    80002326:	cf1ff0ef          	jal	80002016 <brelse>
    return addr;
    8000232a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000232c:	854a                	mv	a0,s2
    8000232e:	70a2                	ld	ra,40(sp)
    80002330:	7402                	ld	s0,32(sp)
    80002332:	64e2                	ld	s1,24(sp)
    80002334:	6942                	ld	s2,16(sp)
    80002336:	69a2                	ld	s3,8(sp)
    80002338:	6145                	addi	sp,sp,48
    8000233a:	8082                	ret
      addr = balloc(ip->dev);
    8000233c:	0009a503          	lw	a0,0(s3)
    80002340:	e33ff0ef          	jal	80002172 <balloc>
    80002344:	0005091b          	sext.w	s2,a0
      if(addr){
    80002348:	fc090ee3          	beqz	s2,80002324 <bmap+0x92>
        a[bn] = addr;
    8000234c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002350:	8552                	mv	a0,s4
    80002352:	50f000ef          	jal	80003060 <log_write>
    80002356:	b7f9                	j	80002324 <bmap+0x92>
    80002358:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000235a:	00005517          	auipc	a0,0x5
    8000235e:	0de50513          	addi	a0,a0,222 # 80007438 <etext+0x438>
    80002362:	090030ef          	jal	800053f2 <panic>

0000000080002366 <iget>:
{
    80002366:	7179                	addi	sp,sp,-48
    80002368:	f406                	sd	ra,40(sp)
    8000236a:	f022                	sd	s0,32(sp)
    8000236c:	ec26                	sd	s1,24(sp)
    8000236e:	e84a                	sd	s2,16(sp)
    80002370:	e44e                	sd	s3,8(sp)
    80002372:	e052                	sd	s4,0(sp)
    80002374:	1800                	addi	s0,sp,48
    80002376:	89aa                	mv	s3,a0
    80002378:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000237a:	00014517          	auipc	a0,0x14
    8000237e:	ace50513          	addi	a0,a0,-1330 # 80015e48 <itable>
    80002382:	39e030ef          	jal	80005720 <acquire>
  empty = 0;
    80002386:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002388:	00014497          	auipc	s1,0x14
    8000238c:	ad848493          	addi	s1,s1,-1320 # 80015e60 <itable+0x18>
    80002390:	00015697          	auipc	a3,0x15
    80002394:	56068693          	addi	a3,a3,1376 # 800178f0 <log>
    80002398:	a039                	j	800023a6 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000239a:	02090963          	beqz	s2,800023cc <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000239e:	08848493          	addi	s1,s1,136
    800023a2:	02d48863          	beq	s1,a3,800023d2 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800023a6:	449c                	lw	a5,8(s1)
    800023a8:	fef059e3          	blez	a5,8000239a <iget+0x34>
    800023ac:	4098                	lw	a4,0(s1)
    800023ae:	ff3716e3          	bne	a4,s3,8000239a <iget+0x34>
    800023b2:	40d8                	lw	a4,4(s1)
    800023b4:	ff4713e3          	bne	a4,s4,8000239a <iget+0x34>
      ip->ref++;
    800023b8:	2785                	addiw	a5,a5,1
    800023ba:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800023bc:	00014517          	auipc	a0,0x14
    800023c0:	a8c50513          	addi	a0,a0,-1396 # 80015e48 <itable>
    800023c4:	3f4030ef          	jal	800057b8 <release>
      return ip;
    800023c8:	8926                	mv	s2,s1
    800023ca:	a02d                	j	800023f4 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800023cc:	fbe9                	bnez	a5,8000239e <iget+0x38>
      empty = ip;
    800023ce:	8926                	mv	s2,s1
    800023d0:	b7f9                	j	8000239e <iget+0x38>
  if(empty == 0)
    800023d2:	02090a63          	beqz	s2,80002406 <iget+0xa0>
  ip->dev = dev;
    800023d6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800023da:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800023de:	4785                	li	a5,1
    800023e0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800023e4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800023e8:	00014517          	auipc	a0,0x14
    800023ec:	a6050513          	addi	a0,a0,-1440 # 80015e48 <itable>
    800023f0:	3c8030ef          	jal	800057b8 <release>
}
    800023f4:	854a                	mv	a0,s2
    800023f6:	70a2                	ld	ra,40(sp)
    800023f8:	7402                	ld	s0,32(sp)
    800023fa:	64e2                	ld	s1,24(sp)
    800023fc:	6942                	ld	s2,16(sp)
    800023fe:	69a2                	ld	s3,8(sp)
    80002400:	6a02                	ld	s4,0(sp)
    80002402:	6145                	addi	sp,sp,48
    80002404:	8082                	ret
    panic("iget: no inodes");
    80002406:	00005517          	auipc	a0,0x5
    8000240a:	04a50513          	addi	a0,a0,74 # 80007450 <etext+0x450>
    8000240e:	7e5020ef          	jal	800053f2 <panic>

0000000080002412 <fsinit>:
fsinit(int dev) {
    80002412:	7179                	addi	sp,sp,-48
    80002414:	f406                	sd	ra,40(sp)
    80002416:	f022                	sd	s0,32(sp)
    80002418:	ec26                	sd	s1,24(sp)
    8000241a:	e84a                	sd	s2,16(sp)
    8000241c:	e44e                	sd	s3,8(sp)
    8000241e:	1800                	addi	s0,sp,48
    80002420:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002422:	4585                	li	a1,1
    80002424:	aebff0ef          	jal	80001f0e <bread>
    80002428:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000242a:	00014997          	auipc	s3,0x14
    8000242e:	9fe98993          	addi	s3,s3,-1538 # 80015e28 <sb>
    80002432:	02000613          	li	a2,32
    80002436:	05850593          	addi	a1,a0,88
    8000243a:	854e                	mv	a0,s3
    8000243c:	d6ffd0ef          	jal	800001aa <memmove>
  brelse(bp);
    80002440:	8526                	mv	a0,s1
    80002442:	bd5ff0ef          	jal	80002016 <brelse>
  if(sb.magic != FSMAGIC)
    80002446:	0009a703          	lw	a4,0(s3)
    8000244a:	102037b7          	lui	a5,0x10203
    8000244e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002452:	02f71063          	bne	a4,a5,80002472 <fsinit+0x60>
  initlog(dev, &sb);
    80002456:	00014597          	auipc	a1,0x14
    8000245a:	9d258593          	addi	a1,a1,-1582 # 80015e28 <sb>
    8000245e:	854a                	mv	a0,s2
    80002460:	1f9000ef          	jal	80002e58 <initlog>
}
    80002464:	70a2                	ld	ra,40(sp)
    80002466:	7402                	ld	s0,32(sp)
    80002468:	64e2                	ld	s1,24(sp)
    8000246a:	6942                	ld	s2,16(sp)
    8000246c:	69a2                	ld	s3,8(sp)
    8000246e:	6145                	addi	sp,sp,48
    80002470:	8082                	ret
    panic("invalid file system");
    80002472:	00005517          	auipc	a0,0x5
    80002476:	fee50513          	addi	a0,a0,-18 # 80007460 <etext+0x460>
    8000247a:	779020ef          	jal	800053f2 <panic>

000000008000247e <iinit>:
{
    8000247e:	7179                	addi	sp,sp,-48
    80002480:	f406                	sd	ra,40(sp)
    80002482:	f022                	sd	s0,32(sp)
    80002484:	ec26                	sd	s1,24(sp)
    80002486:	e84a                	sd	s2,16(sp)
    80002488:	e44e                	sd	s3,8(sp)
    8000248a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000248c:	00005597          	auipc	a1,0x5
    80002490:	fec58593          	addi	a1,a1,-20 # 80007478 <etext+0x478>
    80002494:	00014517          	auipc	a0,0x14
    80002498:	9b450513          	addi	a0,a0,-1612 # 80015e48 <itable>
    8000249c:	204030ef          	jal	800056a0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800024a0:	00014497          	auipc	s1,0x14
    800024a4:	9d048493          	addi	s1,s1,-1584 # 80015e70 <itable+0x28>
    800024a8:	00015997          	auipc	s3,0x15
    800024ac:	45898993          	addi	s3,s3,1112 # 80017900 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800024b0:	00005917          	auipc	s2,0x5
    800024b4:	fd090913          	addi	s2,s2,-48 # 80007480 <etext+0x480>
    800024b8:	85ca                	mv	a1,s2
    800024ba:	8526                	mv	a0,s1
    800024bc:	475000ef          	jal	80003130 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800024c0:	08848493          	addi	s1,s1,136
    800024c4:	ff349ae3          	bne	s1,s3,800024b8 <iinit+0x3a>
}
    800024c8:	70a2                	ld	ra,40(sp)
    800024ca:	7402                	ld	s0,32(sp)
    800024cc:	64e2                	ld	s1,24(sp)
    800024ce:	6942                	ld	s2,16(sp)
    800024d0:	69a2                	ld	s3,8(sp)
    800024d2:	6145                	addi	sp,sp,48
    800024d4:	8082                	ret

00000000800024d6 <ialloc>:
{
    800024d6:	7139                	addi	sp,sp,-64
    800024d8:	fc06                	sd	ra,56(sp)
    800024da:	f822                	sd	s0,48(sp)
    800024dc:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800024de:	00014717          	auipc	a4,0x14
    800024e2:	95672703          	lw	a4,-1706(a4) # 80015e34 <sb+0xc>
    800024e6:	4785                	li	a5,1
    800024e8:	06e7f063          	bgeu	a5,a4,80002548 <ialloc+0x72>
    800024ec:	f426                	sd	s1,40(sp)
    800024ee:	f04a                	sd	s2,32(sp)
    800024f0:	ec4e                	sd	s3,24(sp)
    800024f2:	e852                	sd	s4,16(sp)
    800024f4:	e456                	sd	s5,8(sp)
    800024f6:	e05a                	sd	s6,0(sp)
    800024f8:	8aaa                	mv	s5,a0
    800024fa:	8b2e                	mv	s6,a1
    800024fc:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800024fe:	00014a17          	auipc	s4,0x14
    80002502:	92aa0a13          	addi	s4,s4,-1750 # 80015e28 <sb>
    80002506:	00495593          	srli	a1,s2,0x4
    8000250a:	018a2783          	lw	a5,24(s4)
    8000250e:	9dbd                	addw	a1,a1,a5
    80002510:	8556                	mv	a0,s5
    80002512:	9fdff0ef          	jal	80001f0e <bread>
    80002516:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002518:	05850993          	addi	s3,a0,88
    8000251c:	00f97793          	andi	a5,s2,15
    80002520:	079a                	slli	a5,a5,0x6
    80002522:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002524:	00099783          	lh	a5,0(s3)
    80002528:	cb9d                	beqz	a5,8000255e <ialloc+0x88>
    brelse(bp);
    8000252a:	aedff0ef          	jal	80002016 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000252e:	0905                	addi	s2,s2,1
    80002530:	00ca2703          	lw	a4,12(s4)
    80002534:	0009079b          	sext.w	a5,s2
    80002538:	fce7e7e3          	bltu	a5,a4,80002506 <ialloc+0x30>
    8000253c:	74a2                	ld	s1,40(sp)
    8000253e:	7902                	ld	s2,32(sp)
    80002540:	69e2                	ld	s3,24(sp)
    80002542:	6a42                	ld	s4,16(sp)
    80002544:	6aa2                	ld	s5,8(sp)
    80002546:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002548:	00005517          	auipc	a0,0x5
    8000254c:	f4050513          	addi	a0,a0,-192 # 80007488 <etext+0x488>
    80002550:	3d1020ef          	jal	80005120 <printf>
  return 0;
    80002554:	4501                	li	a0,0
}
    80002556:	70e2                	ld	ra,56(sp)
    80002558:	7442                	ld	s0,48(sp)
    8000255a:	6121                	addi	sp,sp,64
    8000255c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000255e:	04000613          	li	a2,64
    80002562:	4581                	li	a1,0
    80002564:	854e                	mv	a0,s3
    80002566:	be9fd0ef          	jal	8000014e <memset>
      dip->type = type;
    8000256a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000256e:	8526                	mv	a0,s1
    80002570:	2f1000ef          	jal	80003060 <log_write>
      brelse(bp);
    80002574:	8526                	mv	a0,s1
    80002576:	aa1ff0ef          	jal	80002016 <brelse>
      return iget(dev, inum);
    8000257a:	0009059b          	sext.w	a1,s2
    8000257e:	8556                	mv	a0,s5
    80002580:	de7ff0ef          	jal	80002366 <iget>
    80002584:	74a2                	ld	s1,40(sp)
    80002586:	7902                	ld	s2,32(sp)
    80002588:	69e2                	ld	s3,24(sp)
    8000258a:	6a42                	ld	s4,16(sp)
    8000258c:	6aa2                	ld	s5,8(sp)
    8000258e:	6b02                	ld	s6,0(sp)
    80002590:	b7d9                	j	80002556 <ialloc+0x80>

0000000080002592 <iupdate>:
{
    80002592:	1101                	addi	sp,sp,-32
    80002594:	ec06                	sd	ra,24(sp)
    80002596:	e822                	sd	s0,16(sp)
    80002598:	e426                	sd	s1,8(sp)
    8000259a:	e04a                	sd	s2,0(sp)
    8000259c:	1000                	addi	s0,sp,32
    8000259e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800025a0:	415c                	lw	a5,4(a0)
    800025a2:	0047d79b          	srliw	a5,a5,0x4
    800025a6:	00014597          	auipc	a1,0x14
    800025aa:	89a5a583          	lw	a1,-1894(a1) # 80015e40 <sb+0x18>
    800025ae:	9dbd                	addw	a1,a1,a5
    800025b0:	4108                	lw	a0,0(a0)
    800025b2:	95dff0ef          	jal	80001f0e <bread>
    800025b6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800025b8:	05850793          	addi	a5,a0,88
    800025bc:	40d8                	lw	a4,4(s1)
    800025be:	8b3d                	andi	a4,a4,15
    800025c0:	071a                	slli	a4,a4,0x6
    800025c2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800025c4:	04449703          	lh	a4,68(s1)
    800025c8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800025cc:	04649703          	lh	a4,70(s1)
    800025d0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800025d4:	04849703          	lh	a4,72(s1)
    800025d8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800025dc:	04a49703          	lh	a4,74(s1)
    800025e0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800025e4:	44f8                	lw	a4,76(s1)
    800025e6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800025e8:	03400613          	li	a2,52
    800025ec:	05048593          	addi	a1,s1,80
    800025f0:	00c78513          	addi	a0,a5,12
    800025f4:	bb7fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    800025f8:	854a                	mv	a0,s2
    800025fa:	267000ef          	jal	80003060 <log_write>
  brelse(bp);
    800025fe:	854a                	mv	a0,s2
    80002600:	a17ff0ef          	jal	80002016 <brelse>
}
    80002604:	60e2                	ld	ra,24(sp)
    80002606:	6442                	ld	s0,16(sp)
    80002608:	64a2                	ld	s1,8(sp)
    8000260a:	6902                	ld	s2,0(sp)
    8000260c:	6105                	addi	sp,sp,32
    8000260e:	8082                	ret

0000000080002610 <idup>:
{
    80002610:	1101                	addi	sp,sp,-32
    80002612:	ec06                	sd	ra,24(sp)
    80002614:	e822                	sd	s0,16(sp)
    80002616:	e426                	sd	s1,8(sp)
    80002618:	1000                	addi	s0,sp,32
    8000261a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000261c:	00014517          	auipc	a0,0x14
    80002620:	82c50513          	addi	a0,a0,-2004 # 80015e48 <itable>
    80002624:	0fc030ef          	jal	80005720 <acquire>
  ip->ref++;
    80002628:	449c                	lw	a5,8(s1)
    8000262a:	2785                	addiw	a5,a5,1
    8000262c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000262e:	00014517          	auipc	a0,0x14
    80002632:	81a50513          	addi	a0,a0,-2022 # 80015e48 <itable>
    80002636:	182030ef          	jal	800057b8 <release>
}
    8000263a:	8526                	mv	a0,s1
    8000263c:	60e2                	ld	ra,24(sp)
    8000263e:	6442                	ld	s0,16(sp)
    80002640:	64a2                	ld	s1,8(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret

0000000080002646 <ilock>:
{
    80002646:	1101                	addi	sp,sp,-32
    80002648:	ec06                	sd	ra,24(sp)
    8000264a:	e822                	sd	s0,16(sp)
    8000264c:	e426                	sd	s1,8(sp)
    8000264e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002650:	cd19                	beqz	a0,8000266e <ilock+0x28>
    80002652:	84aa                	mv	s1,a0
    80002654:	451c                	lw	a5,8(a0)
    80002656:	00f05c63          	blez	a5,8000266e <ilock+0x28>
  acquiresleep(&ip->lock);
    8000265a:	0541                	addi	a0,a0,16
    8000265c:	30b000ef          	jal	80003166 <acquiresleep>
  if(ip->valid == 0){
    80002660:	40bc                	lw	a5,64(s1)
    80002662:	cf89                	beqz	a5,8000267c <ilock+0x36>
}
    80002664:	60e2                	ld	ra,24(sp)
    80002666:	6442                	ld	s0,16(sp)
    80002668:	64a2                	ld	s1,8(sp)
    8000266a:	6105                	addi	sp,sp,32
    8000266c:	8082                	ret
    8000266e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002670:	00005517          	auipc	a0,0x5
    80002674:	e3050513          	addi	a0,a0,-464 # 800074a0 <etext+0x4a0>
    80002678:	57b020ef          	jal	800053f2 <panic>
    8000267c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000267e:	40dc                	lw	a5,4(s1)
    80002680:	0047d79b          	srliw	a5,a5,0x4
    80002684:	00013597          	auipc	a1,0x13
    80002688:	7bc5a583          	lw	a1,1980(a1) # 80015e40 <sb+0x18>
    8000268c:	9dbd                	addw	a1,a1,a5
    8000268e:	4088                	lw	a0,0(s1)
    80002690:	87fff0ef          	jal	80001f0e <bread>
    80002694:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002696:	05850593          	addi	a1,a0,88
    8000269a:	40dc                	lw	a5,4(s1)
    8000269c:	8bbd                	andi	a5,a5,15
    8000269e:	079a                	slli	a5,a5,0x6
    800026a0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800026a2:	00059783          	lh	a5,0(a1)
    800026a6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800026aa:	00259783          	lh	a5,2(a1)
    800026ae:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800026b2:	00459783          	lh	a5,4(a1)
    800026b6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800026ba:	00659783          	lh	a5,6(a1)
    800026be:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800026c2:	459c                	lw	a5,8(a1)
    800026c4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800026c6:	03400613          	li	a2,52
    800026ca:	05b1                	addi	a1,a1,12
    800026cc:	05048513          	addi	a0,s1,80
    800026d0:	adbfd0ef          	jal	800001aa <memmove>
    brelse(bp);
    800026d4:	854a                	mv	a0,s2
    800026d6:	941ff0ef          	jal	80002016 <brelse>
    ip->valid = 1;
    800026da:	4785                	li	a5,1
    800026dc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800026de:	04449783          	lh	a5,68(s1)
    800026e2:	c399                	beqz	a5,800026e8 <ilock+0xa2>
    800026e4:	6902                	ld	s2,0(sp)
    800026e6:	bfbd                	j	80002664 <ilock+0x1e>
      panic("ilock: no type");
    800026e8:	00005517          	auipc	a0,0x5
    800026ec:	dc050513          	addi	a0,a0,-576 # 800074a8 <etext+0x4a8>
    800026f0:	503020ef          	jal	800053f2 <panic>

00000000800026f4 <iunlock>:
{
    800026f4:	1101                	addi	sp,sp,-32
    800026f6:	ec06                	sd	ra,24(sp)
    800026f8:	e822                	sd	s0,16(sp)
    800026fa:	e426                	sd	s1,8(sp)
    800026fc:	e04a                	sd	s2,0(sp)
    800026fe:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002700:	c505                	beqz	a0,80002728 <iunlock+0x34>
    80002702:	84aa                	mv	s1,a0
    80002704:	01050913          	addi	s2,a0,16
    80002708:	854a                	mv	a0,s2
    8000270a:	2db000ef          	jal	800031e4 <holdingsleep>
    8000270e:	cd09                	beqz	a0,80002728 <iunlock+0x34>
    80002710:	449c                	lw	a5,8(s1)
    80002712:	00f05b63          	blez	a5,80002728 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002716:	854a                	mv	a0,s2
    80002718:	295000ef          	jal	800031ac <releasesleep>
}
    8000271c:	60e2                	ld	ra,24(sp)
    8000271e:	6442                	ld	s0,16(sp)
    80002720:	64a2                	ld	s1,8(sp)
    80002722:	6902                	ld	s2,0(sp)
    80002724:	6105                	addi	sp,sp,32
    80002726:	8082                	ret
    panic("iunlock");
    80002728:	00005517          	auipc	a0,0x5
    8000272c:	d9050513          	addi	a0,a0,-624 # 800074b8 <etext+0x4b8>
    80002730:	4c3020ef          	jal	800053f2 <panic>

0000000080002734 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002734:	7179                	addi	sp,sp,-48
    80002736:	f406                	sd	ra,40(sp)
    80002738:	f022                	sd	s0,32(sp)
    8000273a:	ec26                	sd	s1,24(sp)
    8000273c:	e84a                	sd	s2,16(sp)
    8000273e:	e44e                	sd	s3,8(sp)
    80002740:	1800                	addi	s0,sp,48
    80002742:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002744:	05050493          	addi	s1,a0,80
    80002748:	08050913          	addi	s2,a0,128
    8000274c:	a021                	j	80002754 <itrunc+0x20>
    8000274e:	0491                	addi	s1,s1,4
    80002750:	01248b63          	beq	s1,s2,80002766 <itrunc+0x32>
    if(ip->addrs[i]){
    80002754:	408c                	lw	a1,0(s1)
    80002756:	dde5                	beqz	a1,8000274e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002758:	0009a503          	lw	a0,0(s3)
    8000275c:	9abff0ef          	jal	80002106 <bfree>
      ip->addrs[i] = 0;
    80002760:	0004a023          	sw	zero,0(s1)
    80002764:	b7ed                	j	8000274e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002766:	0809a583          	lw	a1,128(s3)
    8000276a:	ed89                	bnez	a1,80002784 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000276c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002770:	854e                	mv	a0,s3
    80002772:	e21ff0ef          	jal	80002592 <iupdate>
}
    80002776:	70a2                	ld	ra,40(sp)
    80002778:	7402                	ld	s0,32(sp)
    8000277a:	64e2                	ld	s1,24(sp)
    8000277c:	6942                	ld	s2,16(sp)
    8000277e:	69a2                	ld	s3,8(sp)
    80002780:	6145                	addi	sp,sp,48
    80002782:	8082                	ret
    80002784:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002786:	0009a503          	lw	a0,0(s3)
    8000278a:	f84ff0ef          	jal	80001f0e <bread>
    8000278e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002790:	05850493          	addi	s1,a0,88
    80002794:	45850913          	addi	s2,a0,1112
    80002798:	a021                	j	800027a0 <itrunc+0x6c>
    8000279a:	0491                	addi	s1,s1,4
    8000279c:	01248963          	beq	s1,s2,800027ae <itrunc+0x7a>
      if(a[j])
    800027a0:	408c                	lw	a1,0(s1)
    800027a2:	dde5                	beqz	a1,8000279a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800027a4:	0009a503          	lw	a0,0(s3)
    800027a8:	95fff0ef          	jal	80002106 <bfree>
    800027ac:	b7fd                	j	8000279a <itrunc+0x66>
    brelse(bp);
    800027ae:	8552                	mv	a0,s4
    800027b0:	867ff0ef          	jal	80002016 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800027b4:	0809a583          	lw	a1,128(s3)
    800027b8:	0009a503          	lw	a0,0(s3)
    800027bc:	94bff0ef          	jal	80002106 <bfree>
    ip->addrs[NDIRECT] = 0;
    800027c0:	0809a023          	sw	zero,128(s3)
    800027c4:	6a02                	ld	s4,0(sp)
    800027c6:	b75d                	j	8000276c <itrunc+0x38>

00000000800027c8 <iput>:
{
    800027c8:	1101                	addi	sp,sp,-32
    800027ca:	ec06                	sd	ra,24(sp)
    800027cc:	e822                	sd	s0,16(sp)
    800027ce:	e426                	sd	s1,8(sp)
    800027d0:	1000                	addi	s0,sp,32
    800027d2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027d4:	00013517          	auipc	a0,0x13
    800027d8:	67450513          	addi	a0,a0,1652 # 80015e48 <itable>
    800027dc:	745020ef          	jal	80005720 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800027e0:	4498                	lw	a4,8(s1)
    800027e2:	4785                	li	a5,1
    800027e4:	02f70063          	beq	a4,a5,80002804 <iput+0x3c>
  ip->ref--;
    800027e8:	449c                	lw	a5,8(s1)
    800027ea:	37fd                	addiw	a5,a5,-1
    800027ec:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800027ee:	00013517          	auipc	a0,0x13
    800027f2:	65a50513          	addi	a0,a0,1626 # 80015e48 <itable>
    800027f6:	7c3020ef          	jal	800057b8 <release>
}
    800027fa:	60e2                	ld	ra,24(sp)
    800027fc:	6442                	ld	s0,16(sp)
    800027fe:	64a2                	ld	s1,8(sp)
    80002800:	6105                	addi	sp,sp,32
    80002802:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002804:	40bc                	lw	a5,64(s1)
    80002806:	d3ed                	beqz	a5,800027e8 <iput+0x20>
    80002808:	04a49783          	lh	a5,74(s1)
    8000280c:	fff1                	bnez	a5,800027e8 <iput+0x20>
    8000280e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002810:	01048913          	addi	s2,s1,16
    80002814:	854a                	mv	a0,s2
    80002816:	151000ef          	jal	80003166 <acquiresleep>
    release(&itable.lock);
    8000281a:	00013517          	auipc	a0,0x13
    8000281e:	62e50513          	addi	a0,a0,1582 # 80015e48 <itable>
    80002822:	797020ef          	jal	800057b8 <release>
    itrunc(ip);
    80002826:	8526                	mv	a0,s1
    80002828:	f0dff0ef          	jal	80002734 <itrunc>
    ip->type = 0;
    8000282c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002830:	8526                	mv	a0,s1
    80002832:	d61ff0ef          	jal	80002592 <iupdate>
    ip->valid = 0;
    80002836:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000283a:	854a                	mv	a0,s2
    8000283c:	171000ef          	jal	800031ac <releasesleep>
    acquire(&itable.lock);
    80002840:	00013517          	auipc	a0,0x13
    80002844:	60850513          	addi	a0,a0,1544 # 80015e48 <itable>
    80002848:	6d9020ef          	jal	80005720 <acquire>
    8000284c:	6902                	ld	s2,0(sp)
    8000284e:	bf69                	j	800027e8 <iput+0x20>

0000000080002850 <iunlockput>:
{
    80002850:	1101                	addi	sp,sp,-32
    80002852:	ec06                	sd	ra,24(sp)
    80002854:	e822                	sd	s0,16(sp)
    80002856:	e426                	sd	s1,8(sp)
    80002858:	1000                	addi	s0,sp,32
    8000285a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000285c:	e99ff0ef          	jal	800026f4 <iunlock>
  iput(ip);
    80002860:	8526                	mv	a0,s1
    80002862:	f67ff0ef          	jal	800027c8 <iput>
}
    80002866:	60e2                	ld	ra,24(sp)
    80002868:	6442                	ld	s0,16(sp)
    8000286a:	64a2                	ld	s1,8(sp)
    8000286c:	6105                	addi	sp,sp,32
    8000286e:	8082                	ret

0000000080002870 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002870:	1141                	addi	sp,sp,-16
    80002872:	e422                	sd	s0,8(sp)
    80002874:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002876:	411c                	lw	a5,0(a0)
    80002878:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000287a:	415c                	lw	a5,4(a0)
    8000287c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000287e:	04451783          	lh	a5,68(a0)
    80002882:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002886:	04a51783          	lh	a5,74(a0)
    8000288a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000288e:	04c56783          	lwu	a5,76(a0)
    80002892:	e99c                	sd	a5,16(a1)
}
    80002894:	6422                	ld	s0,8(sp)
    80002896:	0141                	addi	sp,sp,16
    80002898:	8082                	ret

000000008000289a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000289a:	457c                	lw	a5,76(a0)
    8000289c:	0ed7eb63          	bltu	a5,a3,80002992 <readi+0xf8>
{
    800028a0:	7159                	addi	sp,sp,-112
    800028a2:	f486                	sd	ra,104(sp)
    800028a4:	f0a2                	sd	s0,96(sp)
    800028a6:	eca6                	sd	s1,88(sp)
    800028a8:	e0d2                	sd	s4,64(sp)
    800028aa:	fc56                	sd	s5,56(sp)
    800028ac:	f85a                	sd	s6,48(sp)
    800028ae:	f45e                	sd	s7,40(sp)
    800028b0:	1880                	addi	s0,sp,112
    800028b2:	8b2a                	mv	s6,a0
    800028b4:	8bae                	mv	s7,a1
    800028b6:	8a32                	mv	s4,a2
    800028b8:	84b6                	mv	s1,a3
    800028ba:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800028bc:	9f35                	addw	a4,a4,a3
    return 0;
    800028be:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800028c0:	0cd76063          	bltu	a4,a3,80002980 <readi+0xe6>
    800028c4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800028c6:	00e7f463          	bgeu	a5,a4,800028ce <readi+0x34>
    n = ip->size - off;
    800028ca:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800028ce:	080a8f63          	beqz	s5,8000296c <readi+0xd2>
    800028d2:	e8ca                	sd	s2,80(sp)
    800028d4:	f062                	sd	s8,32(sp)
    800028d6:	ec66                	sd	s9,24(sp)
    800028d8:	e86a                	sd	s10,16(sp)
    800028da:	e46e                	sd	s11,8(sp)
    800028dc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800028de:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800028e2:	5c7d                	li	s8,-1
    800028e4:	a80d                	j	80002916 <readi+0x7c>
    800028e6:	020d1d93          	slli	s11,s10,0x20
    800028ea:	020ddd93          	srli	s11,s11,0x20
    800028ee:	05890613          	addi	a2,s2,88
    800028f2:	86ee                	mv	a3,s11
    800028f4:	963a                	add	a2,a2,a4
    800028f6:	85d2                	mv	a1,s4
    800028f8:	855e                	mv	a0,s7
    800028fa:	d97fe0ef          	jal	80001690 <either_copyout>
    800028fe:	05850763          	beq	a0,s8,8000294c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002902:	854a                	mv	a0,s2
    80002904:	f12ff0ef          	jal	80002016 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002908:	013d09bb          	addw	s3,s10,s3
    8000290c:	009d04bb          	addw	s1,s10,s1
    80002910:	9a6e                	add	s4,s4,s11
    80002912:	0559f763          	bgeu	s3,s5,80002960 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002916:	00a4d59b          	srliw	a1,s1,0xa
    8000291a:	855a                	mv	a0,s6
    8000291c:	977ff0ef          	jal	80002292 <bmap>
    80002920:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002924:	c5b1                	beqz	a1,80002970 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002926:	000b2503          	lw	a0,0(s6)
    8000292a:	de4ff0ef          	jal	80001f0e <bread>
    8000292e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002930:	3ff4f713          	andi	a4,s1,1023
    80002934:	40ec87bb          	subw	a5,s9,a4
    80002938:	413a86bb          	subw	a3,s5,s3
    8000293c:	8d3e                	mv	s10,a5
    8000293e:	2781                	sext.w	a5,a5
    80002940:	0006861b          	sext.w	a2,a3
    80002944:	faf671e3          	bgeu	a2,a5,800028e6 <readi+0x4c>
    80002948:	8d36                	mv	s10,a3
    8000294a:	bf71                	j	800028e6 <readi+0x4c>
      brelse(bp);
    8000294c:	854a                	mv	a0,s2
    8000294e:	ec8ff0ef          	jal	80002016 <brelse>
      tot = -1;
    80002952:	59fd                	li	s3,-1
      break;
    80002954:	6946                	ld	s2,80(sp)
    80002956:	7c02                	ld	s8,32(sp)
    80002958:	6ce2                	ld	s9,24(sp)
    8000295a:	6d42                	ld	s10,16(sp)
    8000295c:	6da2                	ld	s11,8(sp)
    8000295e:	a831                	j	8000297a <readi+0xe0>
    80002960:	6946                	ld	s2,80(sp)
    80002962:	7c02                	ld	s8,32(sp)
    80002964:	6ce2                	ld	s9,24(sp)
    80002966:	6d42                	ld	s10,16(sp)
    80002968:	6da2                	ld	s11,8(sp)
    8000296a:	a801                	j	8000297a <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000296c:	89d6                	mv	s3,s5
    8000296e:	a031                	j	8000297a <readi+0xe0>
    80002970:	6946                	ld	s2,80(sp)
    80002972:	7c02                	ld	s8,32(sp)
    80002974:	6ce2                	ld	s9,24(sp)
    80002976:	6d42                	ld	s10,16(sp)
    80002978:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000297a:	0009851b          	sext.w	a0,s3
    8000297e:	69a6                	ld	s3,72(sp)
}
    80002980:	70a6                	ld	ra,104(sp)
    80002982:	7406                	ld	s0,96(sp)
    80002984:	64e6                	ld	s1,88(sp)
    80002986:	6a06                	ld	s4,64(sp)
    80002988:	7ae2                	ld	s5,56(sp)
    8000298a:	7b42                	ld	s6,48(sp)
    8000298c:	7ba2                	ld	s7,40(sp)
    8000298e:	6165                	addi	sp,sp,112
    80002990:	8082                	ret
    return 0;
    80002992:	4501                	li	a0,0
}
    80002994:	8082                	ret

0000000080002996 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002996:	457c                	lw	a5,76(a0)
    80002998:	10d7e063          	bltu	a5,a3,80002a98 <writei+0x102>
{
    8000299c:	7159                	addi	sp,sp,-112
    8000299e:	f486                	sd	ra,104(sp)
    800029a0:	f0a2                	sd	s0,96(sp)
    800029a2:	e8ca                	sd	s2,80(sp)
    800029a4:	e0d2                	sd	s4,64(sp)
    800029a6:	fc56                	sd	s5,56(sp)
    800029a8:	f85a                	sd	s6,48(sp)
    800029aa:	f45e                	sd	s7,40(sp)
    800029ac:	1880                	addi	s0,sp,112
    800029ae:	8aaa                	mv	s5,a0
    800029b0:	8bae                	mv	s7,a1
    800029b2:	8a32                	mv	s4,a2
    800029b4:	8936                	mv	s2,a3
    800029b6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800029b8:	00e687bb          	addw	a5,a3,a4
    800029bc:	0ed7e063          	bltu	a5,a3,80002a9c <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800029c0:	00043737          	lui	a4,0x43
    800029c4:	0cf76e63          	bltu	a4,a5,80002aa0 <writei+0x10a>
    800029c8:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029ca:	0a0b0f63          	beqz	s6,80002a88 <writei+0xf2>
    800029ce:	eca6                	sd	s1,88(sp)
    800029d0:	f062                	sd	s8,32(sp)
    800029d2:	ec66                	sd	s9,24(sp)
    800029d4:	e86a                	sd	s10,16(sp)
    800029d6:	e46e                	sd	s11,8(sp)
    800029d8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029da:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800029de:	5c7d                	li	s8,-1
    800029e0:	a825                	j	80002a18 <writei+0x82>
    800029e2:	020d1d93          	slli	s11,s10,0x20
    800029e6:	020ddd93          	srli	s11,s11,0x20
    800029ea:	05848513          	addi	a0,s1,88
    800029ee:	86ee                	mv	a3,s11
    800029f0:	8652                	mv	a2,s4
    800029f2:	85de                	mv	a1,s7
    800029f4:	953a                	add	a0,a0,a4
    800029f6:	ce5fe0ef          	jal	800016da <either_copyin>
    800029fa:	05850a63          	beq	a0,s8,80002a4e <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800029fe:	8526                	mv	a0,s1
    80002a00:	660000ef          	jal	80003060 <log_write>
    brelse(bp);
    80002a04:	8526                	mv	a0,s1
    80002a06:	e10ff0ef          	jal	80002016 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a0a:	013d09bb          	addw	s3,s10,s3
    80002a0e:	012d093b          	addw	s2,s10,s2
    80002a12:	9a6e                	add	s4,s4,s11
    80002a14:	0569f063          	bgeu	s3,s6,80002a54 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002a18:	00a9559b          	srliw	a1,s2,0xa
    80002a1c:	8556                	mv	a0,s5
    80002a1e:	875ff0ef          	jal	80002292 <bmap>
    80002a22:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a26:	c59d                	beqz	a1,80002a54 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002a28:	000aa503          	lw	a0,0(s5)
    80002a2c:	ce2ff0ef          	jal	80001f0e <bread>
    80002a30:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a32:	3ff97713          	andi	a4,s2,1023
    80002a36:	40ec87bb          	subw	a5,s9,a4
    80002a3a:	413b06bb          	subw	a3,s6,s3
    80002a3e:	8d3e                	mv	s10,a5
    80002a40:	2781                	sext.w	a5,a5
    80002a42:	0006861b          	sext.w	a2,a3
    80002a46:	f8f67ee3          	bgeu	a2,a5,800029e2 <writei+0x4c>
    80002a4a:	8d36                	mv	s10,a3
    80002a4c:	bf59                	j	800029e2 <writei+0x4c>
      brelse(bp);
    80002a4e:	8526                	mv	a0,s1
    80002a50:	dc6ff0ef          	jal	80002016 <brelse>
  }

  if(off > ip->size)
    80002a54:	04caa783          	lw	a5,76(s5)
    80002a58:	0327fa63          	bgeu	a5,s2,80002a8c <writei+0xf6>
    ip->size = off;
    80002a5c:	052aa623          	sw	s2,76(s5)
    80002a60:	64e6                	ld	s1,88(sp)
    80002a62:	7c02                	ld	s8,32(sp)
    80002a64:	6ce2                	ld	s9,24(sp)
    80002a66:	6d42                	ld	s10,16(sp)
    80002a68:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002a6a:	8556                	mv	a0,s5
    80002a6c:	b27ff0ef          	jal	80002592 <iupdate>

  return tot;
    80002a70:	0009851b          	sext.w	a0,s3
    80002a74:	69a6                	ld	s3,72(sp)
}
    80002a76:	70a6                	ld	ra,104(sp)
    80002a78:	7406                	ld	s0,96(sp)
    80002a7a:	6946                	ld	s2,80(sp)
    80002a7c:	6a06                	ld	s4,64(sp)
    80002a7e:	7ae2                	ld	s5,56(sp)
    80002a80:	7b42                	ld	s6,48(sp)
    80002a82:	7ba2                	ld	s7,40(sp)
    80002a84:	6165                	addi	sp,sp,112
    80002a86:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a88:	89da                	mv	s3,s6
    80002a8a:	b7c5                	j	80002a6a <writei+0xd4>
    80002a8c:	64e6                	ld	s1,88(sp)
    80002a8e:	7c02                	ld	s8,32(sp)
    80002a90:	6ce2                	ld	s9,24(sp)
    80002a92:	6d42                	ld	s10,16(sp)
    80002a94:	6da2                	ld	s11,8(sp)
    80002a96:	bfd1                	j	80002a6a <writei+0xd4>
    return -1;
    80002a98:	557d                	li	a0,-1
}
    80002a9a:	8082                	ret
    return -1;
    80002a9c:	557d                	li	a0,-1
    80002a9e:	bfe1                	j	80002a76 <writei+0xe0>
    return -1;
    80002aa0:	557d                	li	a0,-1
    80002aa2:	bfd1                	j	80002a76 <writei+0xe0>

0000000080002aa4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002aa4:	1141                	addi	sp,sp,-16
    80002aa6:	e406                	sd	ra,8(sp)
    80002aa8:	e022                	sd	s0,0(sp)
    80002aaa:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002aac:	4639                	li	a2,14
    80002aae:	f6cfd0ef          	jal	8000021a <strncmp>
}
    80002ab2:	60a2                	ld	ra,8(sp)
    80002ab4:	6402                	ld	s0,0(sp)
    80002ab6:	0141                	addi	sp,sp,16
    80002ab8:	8082                	ret

0000000080002aba <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002aba:	7139                	addi	sp,sp,-64
    80002abc:	fc06                	sd	ra,56(sp)
    80002abe:	f822                	sd	s0,48(sp)
    80002ac0:	f426                	sd	s1,40(sp)
    80002ac2:	f04a                	sd	s2,32(sp)
    80002ac4:	ec4e                	sd	s3,24(sp)
    80002ac6:	e852                	sd	s4,16(sp)
    80002ac8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002aca:	04451703          	lh	a4,68(a0)
    80002ace:	4785                	li	a5,1
    80002ad0:	00f71a63          	bne	a4,a5,80002ae4 <dirlookup+0x2a>
    80002ad4:	892a                	mv	s2,a0
    80002ad6:	89ae                	mv	s3,a1
    80002ad8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ada:	457c                	lw	a5,76(a0)
    80002adc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ade:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ae0:	e39d                	bnez	a5,80002b06 <dirlookup+0x4c>
    80002ae2:	a095                	j	80002b46 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002ae4:	00005517          	auipc	a0,0x5
    80002ae8:	9dc50513          	addi	a0,a0,-1572 # 800074c0 <etext+0x4c0>
    80002aec:	107020ef          	jal	800053f2 <panic>
      panic("dirlookup read");
    80002af0:	00005517          	auipc	a0,0x5
    80002af4:	9e850513          	addi	a0,a0,-1560 # 800074d8 <etext+0x4d8>
    80002af8:	0fb020ef          	jal	800053f2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002afc:	24c1                	addiw	s1,s1,16
    80002afe:	04c92783          	lw	a5,76(s2)
    80002b02:	04f4f163          	bgeu	s1,a5,80002b44 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002b06:	4741                	li	a4,16
    80002b08:	86a6                	mv	a3,s1
    80002b0a:	fc040613          	addi	a2,s0,-64
    80002b0e:	4581                	li	a1,0
    80002b10:	854a                	mv	a0,s2
    80002b12:	d89ff0ef          	jal	8000289a <readi>
    80002b16:	47c1                	li	a5,16
    80002b18:	fcf51ce3          	bne	a0,a5,80002af0 <dirlookup+0x36>
    if(de.inum == 0)
    80002b1c:	fc045783          	lhu	a5,-64(s0)
    80002b20:	dff1                	beqz	a5,80002afc <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002b22:	fc240593          	addi	a1,s0,-62
    80002b26:	854e                	mv	a0,s3
    80002b28:	f7dff0ef          	jal	80002aa4 <namecmp>
    80002b2c:	f961                	bnez	a0,80002afc <dirlookup+0x42>
      if(poff)
    80002b2e:	000a0463          	beqz	s4,80002b36 <dirlookup+0x7c>
        *poff = off;
    80002b32:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002b36:	fc045583          	lhu	a1,-64(s0)
    80002b3a:	00092503          	lw	a0,0(s2)
    80002b3e:	829ff0ef          	jal	80002366 <iget>
    80002b42:	a011                	j	80002b46 <dirlookup+0x8c>
  return 0;
    80002b44:	4501                	li	a0,0
}
    80002b46:	70e2                	ld	ra,56(sp)
    80002b48:	7442                	ld	s0,48(sp)
    80002b4a:	74a2                	ld	s1,40(sp)
    80002b4c:	7902                	ld	s2,32(sp)
    80002b4e:	69e2                	ld	s3,24(sp)
    80002b50:	6a42                	ld	s4,16(sp)
    80002b52:	6121                	addi	sp,sp,64
    80002b54:	8082                	ret

0000000080002b56 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002b56:	711d                	addi	sp,sp,-96
    80002b58:	ec86                	sd	ra,88(sp)
    80002b5a:	e8a2                	sd	s0,80(sp)
    80002b5c:	e4a6                	sd	s1,72(sp)
    80002b5e:	e0ca                	sd	s2,64(sp)
    80002b60:	fc4e                	sd	s3,56(sp)
    80002b62:	f852                	sd	s4,48(sp)
    80002b64:	f456                	sd	s5,40(sp)
    80002b66:	f05a                	sd	s6,32(sp)
    80002b68:	ec5e                	sd	s7,24(sp)
    80002b6a:	e862                	sd	s8,16(sp)
    80002b6c:	e466                	sd	s9,8(sp)
    80002b6e:	1080                	addi	s0,sp,96
    80002b70:	84aa                	mv	s1,a0
    80002b72:	8b2e                	mv	s6,a1
    80002b74:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002b76:	00054703          	lbu	a4,0(a0)
    80002b7a:	02f00793          	li	a5,47
    80002b7e:	00f70e63          	beq	a4,a5,80002b9a <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002b82:	9e4fe0ef          	jal	80000d66 <myproc>
    80002b86:	15053503          	ld	a0,336(a0)
    80002b8a:	a87ff0ef          	jal	80002610 <idup>
    80002b8e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002b90:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002b94:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002b96:	4b85                	li	s7,1
    80002b98:	a871                	j	80002c34 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002b9a:	4585                	li	a1,1
    80002b9c:	4505                	li	a0,1
    80002b9e:	fc8ff0ef          	jal	80002366 <iget>
    80002ba2:	8a2a                	mv	s4,a0
    80002ba4:	b7f5                	j	80002b90 <namex+0x3a>
      iunlockput(ip);
    80002ba6:	8552                	mv	a0,s4
    80002ba8:	ca9ff0ef          	jal	80002850 <iunlockput>
      return 0;
    80002bac:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002bae:	8552                	mv	a0,s4
    80002bb0:	60e6                	ld	ra,88(sp)
    80002bb2:	6446                	ld	s0,80(sp)
    80002bb4:	64a6                	ld	s1,72(sp)
    80002bb6:	6906                	ld	s2,64(sp)
    80002bb8:	79e2                	ld	s3,56(sp)
    80002bba:	7a42                	ld	s4,48(sp)
    80002bbc:	7aa2                	ld	s5,40(sp)
    80002bbe:	7b02                	ld	s6,32(sp)
    80002bc0:	6be2                	ld	s7,24(sp)
    80002bc2:	6c42                	ld	s8,16(sp)
    80002bc4:	6ca2                	ld	s9,8(sp)
    80002bc6:	6125                	addi	sp,sp,96
    80002bc8:	8082                	ret
      iunlock(ip);
    80002bca:	8552                	mv	a0,s4
    80002bcc:	b29ff0ef          	jal	800026f4 <iunlock>
      return ip;
    80002bd0:	bff9                	j	80002bae <namex+0x58>
      iunlockput(ip);
    80002bd2:	8552                	mv	a0,s4
    80002bd4:	c7dff0ef          	jal	80002850 <iunlockput>
      return 0;
    80002bd8:	8a4e                	mv	s4,s3
    80002bda:	bfd1                	j	80002bae <namex+0x58>
  len = path - s;
    80002bdc:	40998633          	sub	a2,s3,s1
    80002be0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002be4:	099c5063          	bge	s8,s9,80002c64 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002be8:	4639                	li	a2,14
    80002bea:	85a6                	mv	a1,s1
    80002bec:	8556                	mv	a0,s5
    80002bee:	dbcfd0ef          	jal	800001aa <memmove>
    80002bf2:	84ce                	mv	s1,s3
  while(*path == '/')
    80002bf4:	0004c783          	lbu	a5,0(s1)
    80002bf8:	01279763          	bne	a5,s2,80002c06 <namex+0xb0>
    path++;
    80002bfc:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002bfe:	0004c783          	lbu	a5,0(s1)
    80002c02:	ff278de3          	beq	a5,s2,80002bfc <namex+0xa6>
    ilock(ip);
    80002c06:	8552                	mv	a0,s4
    80002c08:	a3fff0ef          	jal	80002646 <ilock>
    if(ip->type != T_DIR){
    80002c0c:	044a1783          	lh	a5,68(s4)
    80002c10:	f9779be3          	bne	a5,s7,80002ba6 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002c14:	000b0563          	beqz	s6,80002c1e <namex+0xc8>
    80002c18:	0004c783          	lbu	a5,0(s1)
    80002c1c:	d7dd                	beqz	a5,80002bca <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002c1e:	4601                	li	a2,0
    80002c20:	85d6                	mv	a1,s5
    80002c22:	8552                	mv	a0,s4
    80002c24:	e97ff0ef          	jal	80002aba <dirlookup>
    80002c28:	89aa                	mv	s3,a0
    80002c2a:	d545                	beqz	a0,80002bd2 <namex+0x7c>
    iunlockput(ip);
    80002c2c:	8552                	mv	a0,s4
    80002c2e:	c23ff0ef          	jal	80002850 <iunlockput>
    ip = next;
    80002c32:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002c34:	0004c783          	lbu	a5,0(s1)
    80002c38:	01279763          	bne	a5,s2,80002c46 <namex+0xf0>
    path++;
    80002c3c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002c3e:	0004c783          	lbu	a5,0(s1)
    80002c42:	ff278de3          	beq	a5,s2,80002c3c <namex+0xe6>
  if(*path == 0)
    80002c46:	cb8d                	beqz	a5,80002c78 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002c48:	0004c783          	lbu	a5,0(s1)
    80002c4c:	89a6                	mv	s3,s1
  len = path - s;
    80002c4e:	4c81                	li	s9,0
    80002c50:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002c52:	01278963          	beq	a5,s2,80002c64 <namex+0x10e>
    80002c56:	d3d9                	beqz	a5,80002bdc <namex+0x86>
    path++;
    80002c58:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002c5a:	0009c783          	lbu	a5,0(s3)
    80002c5e:	ff279ce3          	bne	a5,s2,80002c56 <namex+0x100>
    80002c62:	bfad                	j	80002bdc <namex+0x86>
    memmove(name, s, len);
    80002c64:	2601                	sext.w	a2,a2
    80002c66:	85a6                	mv	a1,s1
    80002c68:	8556                	mv	a0,s5
    80002c6a:	d40fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002c6e:	9cd6                	add	s9,s9,s5
    80002c70:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002c74:	84ce                	mv	s1,s3
    80002c76:	bfbd                	j	80002bf4 <namex+0x9e>
  if(nameiparent){
    80002c78:	f20b0be3          	beqz	s6,80002bae <namex+0x58>
    iput(ip);
    80002c7c:	8552                	mv	a0,s4
    80002c7e:	b4bff0ef          	jal	800027c8 <iput>
    return 0;
    80002c82:	4a01                	li	s4,0
    80002c84:	b72d                	j	80002bae <namex+0x58>

0000000080002c86 <dirlink>:
{
    80002c86:	7139                	addi	sp,sp,-64
    80002c88:	fc06                	sd	ra,56(sp)
    80002c8a:	f822                	sd	s0,48(sp)
    80002c8c:	f04a                	sd	s2,32(sp)
    80002c8e:	ec4e                	sd	s3,24(sp)
    80002c90:	e852                	sd	s4,16(sp)
    80002c92:	0080                	addi	s0,sp,64
    80002c94:	892a                	mv	s2,a0
    80002c96:	8a2e                	mv	s4,a1
    80002c98:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002c9a:	4601                	li	a2,0
    80002c9c:	e1fff0ef          	jal	80002aba <dirlookup>
    80002ca0:	e535                	bnez	a0,80002d0c <dirlink+0x86>
    80002ca2:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ca4:	04c92483          	lw	s1,76(s2)
    80002ca8:	c48d                	beqz	s1,80002cd2 <dirlink+0x4c>
    80002caa:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cac:	4741                	li	a4,16
    80002cae:	86a6                	mv	a3,s1
    80002cb0:	fc040613          	addi	a2,s0,-64
    80002cb4:	4581                	li	a1,0
    80002cb6:	854a                	mv	a0,s2
    80002cb8:	be3ff0ef          	jal	8000289a <readi>
    80002cbc:	47c1                	li	a5,16
    80002cbe:	04f51b63          	bne	a0,a5,80002d14 <dirlink+0x8e>
    if(de.inum == 0)
    80002cc2:	fc045783          	lhu	a5,-64(s0)
    80002cc6:	c791                	beqz	a5,80002cd2 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cc8:	24c1                	addiw	s1,s1,16
    80002cca:	04c92783          	lw	a5,76(s2)
    80002cce:	fcf4efe3          	bltu	s1,a5,80002cac <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002cd2:	4639                	li	a2,14
    80002cd4:	85d2                	mv	a1,s4
    80002cd6:	fc240513          	addi	a0,s0,-62
    80002cda:	d76fd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002cde:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ce2:	4741                	li	a4,16
    80002ce4:	86a6                	mv	a3,s1
    80002ce6:	fc040613          	addi	a2,s0,-64
    80002cea:	4581                	li	a1,0
    80002cec:	854a                	mv	a0,s2
    80002cee:	ca9ff0ef          	jal	80002996 <writei>
    80002cf2:	1541                	addi	a0,a0,-16
    80002cf4:	00a03533          	snez	a0,a0
    80002cf8:	40a00533          	neg	a0,a0
    80002cfc:	74a2                	ld	s1,40(sp)
}
    80002cfe:	70e2                	ld	ra,56(sp)
    80002d00:	7442                	ld	s0,48(sp)
    80002d02:	7902                	ld	s2,32(sp)
    80002d04:	69e2                	ld	s3,24(sp)
    80002d06:	6a42                	ld	s4,16(sp)
    80002d08:	6121                	addi	sp,sp,64
    80002d0a:	8082                	ret
    iput(ip);
    80002d0c:	abdff0ef          	jal	800027c8 <iput>
    return -1;
    80002d10:	557d                	li	a0,-1
    80002d12:	b7f5                	j	80002cfe <dirlink+0x78>
      panic("dirlink read");
    80002d14:	00004517          	auipc	a0,0x4
    80002d18:	7d450513          	addi	a0,a0,2004 # 800074e8 <etext+0x4e8>
    80002d1c:	6d6020ef          	jal	800053f2 <panic>

0000000080002d20 <namei>:

struct inode*
namei(char *path)
{
    80002d20:	1101                	addi	sp,sp,-32
    80002d22:	ec06                	sd	ra,24(sp)
    80002d24:	e822                	sd	s0,16(sp)
    80002d26:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002d28:	fe040613          	addi	a2,s0,-32
    80002d2c:	4581                	li	a1,0
    80002d2e:	e29ff0ef          	jal	80002b56 <namex>
}
    80002d32:	60e2                	ld	ra,24(sp)
    80002d34:	6442                	ld	s0,16(sp)
    80002d36:	6105                	addi	sp,sp,32
    80002d38:	8082                	ret

0000000080002d3a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002d3a:	1141                	addi	sp,sp,-16
    80002d3c:	e406                	sd	ra,8(sp)
    80002d3e:	e022                	sd	s0,0(sp)
    80002d40:	0800                	addi	s0,sp,16
    80002d42:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002d44:	4585                	li	a1,1
    80002d46:	e11ff0ef          	jal	80002b56 <namex>
}
    80002d4a:	60a2                	ld	ra,8(sp)
    80002d4c:	6402                	ld	s0,0(sp)
    80002d4e:	0141                	addi	sp,sp,16
    80002d50:	8082                	ret

0000000080002d52 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002d52:	1101                	addi	sp,sp,-32
    80002d54:	ec06                	sd	ra,24(sp)
    80002d56:	e822                	sd	s0,16(sp)
    80002d58:	e426                	sd	s1,8(sp)
    80002d5a:	e04a                	sd	s2,0(sp)
    80002d5c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002d5e:	00015917          	auipc	s2,0x15
    80002d62:	b9290913          	addi	s2,s2,-1134 # 800178f0 <log>
    80002d66:	01892583          	lw	a1,24(s2)
    80002d6a:	02892503          	lw	a0,40(s2)
    80002d6e:	9a0ff0ef          	jal	80001f0e <bread>
    80002d72:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002d74:	02c92603          	lw	a2,44(s2)
    80002d78:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002d7a:	00c05f63          	blez	a2,80002d98 <write_head+0x46>
    80002d7e:	00015717          	auipc	a4,0x15
    80002d82:	ba270713          	addi	a4,a4,-1118 # 80017920 <log+0x30>
    80002d86:	87aa                	mv	a5,a0
    80002d88:	060a                	slli	a2,a2,0x2
    80002d8a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002d8c:	4314                	lw	a3,0(a4)
    80002d8e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002d90:	0711                	addi	a4,a4,4
    80002d92:	0791                	addi	a5,a5,4
    80002d94:	fec79ce3          	bne	a5,a2,80002d8c <write_head+0x3a>
  }
  bwrite(buf);
    80002d98:	8526                	mv	a0,s1
    80002d9a:	a4aff0ef          	jal	80001fe4 <bwrite>
  brelse(buf);
    80002d9e:	8526                	mv	a0,s1
    80002da0:	a76ff0ef          	jal	80002016 <brelse>
}
    80002da4:	60e2                	ld	ra,24(sp)
    80002da6:	6442                	ld	s0,16(sp)
    80002da8:	64a2                	ld	s1,8(sp)
    80002daa:	6902                	ld	s2,0(sp)
    80002dac:	6105                	addi	sp,sp,32
    80002dae:	8082                	ret

0000000080002db0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002db0:	00015797          	auipc	a5,0x15
    80002db4:	b6c7a783          	lw	a5,-1172(a5) # 8001791c <log+0x2c>
    80002db8:	08f05f63          	blez	a5,80002e56 <install_trans+0xa6>
{
    80002dbc:	7139                	addi	sp,sp,-64
    80002dbe:	fc06                	sd	ra,56(sp)
    80002dc0:	f822                	sd	s0,48(sp)
    80002dc2:	f426                	sd	s1,40(sp)
    80002dc4:	f04a                	sd	s2,32(sp)
    80002dc6:	ec4e                	sd	s3,24(sp)
    80002dc8:	e852                	sd	s4,16(sp)
    80002dca:	e456                	sd	s5,8(sp)
    80002dcc:	e05a                	sd	s6,0(sp)
    80002dce:	0080                	addi	s0,sp,64
    80002dd0:	8b2a                	mv	s6,a0
    80002dd2:	00015a97          	auipc	s5,0x15
    80002dd6:	b4ea8a93          	addi	s5,s5,-1202 # 80017920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002dda:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ddc:	00015997          	auipc	s3,0x15
    80002de0:	b1498993          	addi	s3,s3,-1260 # 800178f0 <log>
    80002de4:	a829                	j	80002dfe <install_trans+0x4e>
    brelse(lbuf);
    80002de6:	854a                	mv	a0,s2
    80002de8:	a2eff0ef          	jal	80002016 <brelse>
    brelse(dbuf);
    80002dec:	8526                	mv	a0,s1
    80002dee:	a28ff0ef          	jal	80002016 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002df2:	2a05                	addiw	s4,s4,1
    80002df4:	0a91                	addi	s5,s5,4
    80002df6:	02c9a783          	lw	a5,44(s3)
    80002dfa:	04fa5463          	bge	s4,a5,80002e42 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002dfe:	0189a583          	lw	a1,24(s3)
    80002e02:	014585bb          	addw	a1,a1,s4
    80002e06:	2585                	addiw	a1,a1,1
    80002e08:	0289a503          	lw	a0,40(s3)
    80002e0c:	902ff0ef          	jal	80001f0e <bread>
    80002e10:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002e12:	000aa583          	lw	a1,0(s5)
    80002e16:	0289a503          	lw	a0,40(s3)
    80002e1a:	8f4ff0ef          	jal	80001f0e <bread>
    80002e1e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002e20:	40000613          	li	a2,1024
    80002e24:	05890593          	addi	a1,s2,88
    80002e28:	05850513          	addi	a0,a0,88
    80002e2c:	b7efd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80002e30:	8526                	mv	a0,s1
    80002e32:	9b2ff0ef          	jal	80001fe4 <bwrite>
    if(recovering == 0)
    80002e36:	fa0b18e3          	bnez	s6,80002de6 <install_trans+0x36>
      bunpin(dbuf);
    80002e3a:	8526                	mv	a0,s1
    80002e3c:	a96ff0ef          	jal	800020d2 <bunpin>
    80002e40:	b75d                	j	80002de6 <install_trans+0x36>
}
    80002e42:	70e2                	ld	ra,56(sp)
    80002e44:	7442                	ld	s0,48(sp)
    80002e46:	74a2                	ld	s1,40(sp)
    80002e48:	7902                	ld	s2,32(sp)
    80002e4a:	69e2                	ld	s3,24(sp)
    80002e4c:	6a42                	ld	s4,16(sp)
    80002e4e:	6aa2                	ld	s5,8(sp)
    80002e50:	6b02                	ld	s6,0(sp)
    80002e52:	6121                	addi	sp,sp,64
    80002e54:	8082                	ret
    80002e56:	8082                	ret

0000000080002e58 <initlog>:
{
    80002e58:	7179                	addi	sp,sp,-48
    80002e5a:	f406                	sd	ra,40(sp)
    80002e5c:	f022                	sd	s0,32(sp)
    80002e5e:	ec26                	sd	s1,24(sp)
    80002e60:	e84a                	sd	s2,16(sp)
    80002e62:	e44e                	sd	s3,8(sp)
    80002e64:	1800                	addi	s0,sp,48
    80002e66:	892a                	mv	s2,a0
    80002e68:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002e6a:	00015497          	auipc	s1,0x15
    80002e6e:	a8648493          	addi	s1,s1,-1402 # 800178f0 <log>
    80002e72:	00004597          	auipc	a1,0x4
    80002e76:	68658593          	addi	a1,a1,1670 # 800074f8 <etext+0x4f8>
    80002e7a:	8526                	mv	a0,s1
    80002e7c:	025020ef          	jal	800056a0 <initlock>
  log.start = sb->logstart;
    80002e80:	0149a583          	lw	a1,20(s3)
    80002e84:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002e86:	0109a783          	lw	a5,16(s3)
    80002e8a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002e8c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002e90:	854a                	mv	a0,s2
    80002e92:	87cff0ef          	jal	80001f0e <bread>
  log.lh.n = lh->n;
    80002e96:	4d30                	lw	a2,88(a0)
    80002e98:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002e9a:	00c05f63          	blez	a2,80002eb8 <initlog+0x60>
    80002e9e:	87aa                	mv	a5,a0
    80002ea0:	00015717          	auipc	a4,0x15
    80002ea4:	a8070713          	addi	a4,a4,-1408 # 80017920 <log+0x30>
    80002ea8:	060a                	slli	a2,a2,0x2
    80002eaa:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002eac:	4ff4                	lw	a3,92(a5)
    80002eae:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002eb0:	0791                	addi	a5,a5,4
    80002eb2:	0711                	addi	a4,a4,4
    80002eb4:	fec79ce3          	bne	a5,a2,80002eac <initlog+0x54>
  brelse(buf);
    80002eb8:	95eff0ef          	jal	80002016 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002ebc:	4505                	li	a0,1
    80002ebe:	ef3ff0ef          	jal	80002db0 <install_trans>
  log.lh.n = 0;
    80002ec2:	00015797          	auipc	a5,0x15
    80002ec6:	a407ad23          	sw	zero,-1446(a5) # 8001791c <log+0x2c>
  write_head(); // clear the log
    80002eca:	e89ff0ef          	jal	80002d52 <write_head>
}
    80002ece:	70a2                	ld	ra,40(sp)
    80002ed0:	7402                	ld	s0,32(sp)
    80002ed2:	64e2                	ld	s1,24(sp)
    80002ed4:	6942                	ld	s2,16(sp)
    80002ed6:	69a2                	ld	s3,8(sp)
    80002ed8:	6145                	addi	sp,sp,48
    80002eda:	8082                	ret

0000000080002edc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002edc:	1101                	addi	sp,sp,-32
    80002ede:	ec06                	sd	ra,24(sp)
    80002ee0:	e822                	sd	s0,16(sp)
    80002ee2:	e426                	sd	s1,8(sp)
    80002ee4:	e04a                	sd	s2,0(sp)
    80002ee6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002ee8:	00015517          	auipc	a0,0x15
    80002eec:	a0850513          	addi	a0,a0,-1528 # 800178f0 <log>
    80002ef0:	031020ef          	jal	80005720 <acquire>
  while(1){
    if(log.committing){
    80002ef4:	00015497          	auipc	s1,0x15
    80002ef8:	9fc48493          	addi	s1,s1,-1540 # 800178f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002efc:	4979                	li	s2,30
    80002efe:	a029                	j	80002f08 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002f00:	85a6                	mv	a1,s1
    80002f02:	8526                	mv	a0,s1
    80002f04:	c30fe0ef          	jal	80001334 <sleep>
    if(log.committing){
    80002f08:	50dc                	lw	a5,36(s1)
    80002f0a:	fbfd                	bnez	a5,80002f00 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002f0c:	5098                	lw	a4,32(s1)
    80002f0e:	2705                	addiw	a4,a4,1
    80002f10:	0027179b          	slliw	a5,a4,0x2
    80002f14:	9fb9                	addw	a5,a5,a4
    80002f16:	0017979b          	slliw	a5,a5,0x1
    80002f1a:	54d4                	lw	a3,44(s1)
    80002f1c:	9fb5                	addw	a5,a5,a3
    80002f1e:	00f95763          	bge	s2,a5,80002f2c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002f22:	85a6                	mv	a1,s1
    80002f24:	8526                	mv	a0,s1
    80002f26:	c0efe0ef          	jal	80001334 <sleep>
    80002f2a:	bff9                	j	80002f08 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002f2c:	00015517          	auipc	a0,0x15
    80002f30:	9c450513          	addi	a0,a0,-1596 # 800178f0 <log>
    80002f34:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80002f36:	083020ef          	jal	800057b8 <release>
      break;
    }
  }
}
    80002f3a:	60e2                	ld	ra,24(sp)
    80002f3c:	6442                	ld	s0,16(sp)
    80002f3e:	64a2                	ld	s1,8(sp)
    80002f40:	6902                	ld	s2,0(sp)
    80002f42:	6105                	addi	sp,sp,32
    80002f44:	8082                	ret

0000000080002f46 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002f46:	7139                	addi	sp,sp,-64
    80002f48:	fc06                	sd	ra,56(sp)
    80002f4a:	f822                	sd	s0,48(sp)
    80002f4c:	f426                	sd	s1,40(sp)
    80002f4e:	f04a                	sd	s2,32(sp)
    80002f50:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002f52:	00015497          	auipc	s1,0x15
    80002f56:	99e48493          	addi	s1,s1,-1634 # 800178f0 <log>
    80002f5a:	8526                	mv	a0,s1
    80002f5c:	7c4020ef          	jal	80005720 <acquire>
  log.outstanding -= 1;
    80002f60:	509c                	lw	a5,32(s1)
    80002f62:	37fd                	addiw	a5,a5,-1
    80002f64:	0007891b          	sext.w	s2,a5
    80002f68:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80002f6a:	50dc                	lw	a5,36(s1)
    80002f6c:	ef9d                	bnez	a5,80002faa <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80002f6e:	04091763          	bnez	s2,80002fbc <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80002f72:	00015497          	auipc	s1,0x15
    80002f76:	97e48493          	addi	s1,s1,-1666 # 800178f0 <log>
    80002f7a:	4785                	li	a5,1
    80002f7c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80002f7e:	8526                	mv	a0,s1
    80002f80:	039020ef          	jal	800057b8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80002f84:	54dc                	lw	a5,44(s1)
    80002f86:	04f04b63          	bgtz	a5,80002fdc <end_op+0x96>
    acquire(&log.lock);
    80002f8a:	00015497          	auipc	s1,0x15
    80002f8e:	96648493          	addi	s1,s1,-1690 # 800178f0 <log>
    80002f92:	8526                	mv	a0,s1
    80002f94:	78c020ef          	jal	80005720 <acquire>
    log.committing = 0;
    80002f98:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80002f9c:	8526                	mv	a0,s1
    80002f9e:	be2fe0ef          	jal	80001380 <wakeup>
    release(&log.lock);
    80002fa2:	8526                	mv	a0,s1
    80002fa4:	015020ef          	jal	800057b8 <release>
}
    80002fa8:	a025                	j	80002fd0 <end_op+0x8a>
    80002faa:	ec4e                	sd	s3,24(sp)
    80002fac:	e852                	sd	s4,16(sp)
    80002fae:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80002fb0:	00004517          	auipc	a0,0x4
    80002fb4:	55050513          	addi	a0,a0,1360 # 80007500 <etext+0x500>
    80002fb8:	43a020ef          	jal	800053f2 <panic>
    wakeup(&log);
    80002fbc:	00015497          	auipc	s1,0x15
    80002fc0:	93448493          	addi	s1,s1,-1740 # 800178f0 <log>
    80002fc4:	8526                	mv	a0,s1
    80002fc6:	bbafe0ef          	jal	80001380 <wakeup>
  release(&log.lock);
    80002fca:	8526                	mv	a0,s1
    80002fcc:	7ec020ef          	jal	800057b8 <release>
}
    80002fd0:	70e2                	ld	ra,56(sp)
    80002fd2:	7442                	ld	s0,48(sp)
    80002fd4:	74a2                	ld	s1,40(sp)
    80002fd6:	7902                	ld	s2,32(sp)
    80002fd8:	6121                	addi	sp,sp,64
    80002fda:	8082                	ret
    80002fdc:	ec4e                	sd	s3,24(sp)
    80002fde:	e852                	sd	s4,16(sp)
    80002fe0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fe2:	00015a97          	auipc	s5,0x15
    80002fe6:	93ea8a93          	addi	s5,s5,-1730 # 80017920 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002fea:	00015a17          	auipc	s4,0x15
    80002fee:	906a0a13          	addi	s4,s4,-1786 # 800178f0 <log>
    80002ff2:	018a2583          	lw	a1,24(s4)
    80002ff6:	012585bb          	addw	a1,a1,s2
    80002ffa:	2585                	addiw	a1,a1,1
    80002ffc:	028a2503          	lw	a0,40(s4)
    80003000:	f0ffe0ef          	jal	80001f0e <bread>
    80003004:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003006:	000aa583          	lw	a1,0(s5)
    8000300a:	028a2503          	lw	a0,40(s4)
    8000300e:	f01fe0ef          	jal	80001f0e <bread>
    80003012:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003014:	40000613          	li	a2,1024
    80003018:	05850593          	addi	a1,a0,88
    8000301c:	05848513          	addi	a0,s1,88
    80003020:	98afd0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    80003024:	8526                	mv	a0,s1
    80003026:	fbffe0ef          	jal	80001fe4 <bwrite>
    brelse(from);
    8000302a:	854e                	mv	a0,s3
    8000302c:	febfe0ef          	jal	80002016 <brelse>
    brelse(to);
    80003030:	8526                	mv	a0,s1
    80003032:	fe5fe0ef          	jal	80002016 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003036:	2905                	addiw	s2,s2,1
    80003038:	0a91                	addi	s5,s5,4
    8000303a:	02ca2783          	lw	a5,44(s4)
    8000303e:	faf94ae3          	blt	s2,a5,80002ff2 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003042:	d11ff0ef          	jal	80002d52 <write_head>
    install_trans(0); // Now install writes to home locations
    80003046:	4501                	li	a0,0
    80003048:	d69ff0ef          	jal	80002db0 <install_trans>
    log.lh.n = 0;
    8000304c:	00015797          	auipc	a5,0x15
    80003050:	8c07a823          	sw	zero,-1840(a5) # 8001791c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003054:	cffff0ef          	jal	80002d52 <write_head>
    80003058:	69e2                	ld	s3,24(sp)
    8000305a:	6a42                	ld	s4,16(sp)
    8000305c:	6aa2                	ld	s5,8(sp)
    8000305e:	b735                	j	80002f8a <end_op+0x44>

0000000080003060 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003060:	1101                	addi	sp,sp,-32
    80003062:	ec06                	sd	ra,24(sp)
    80003064:	e822                	sd	s0,16(sp)
    80003066:	e426                	sd	s1,8(sp)
    80003068:	e04a                	sd	s2,0(sp)
    8000306a:	1000                	addi	s0,sp,32
    8000306c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000306e:	00015917          	auipc	s2,0x15
    80003072:	88290913          	addi	s2,s2,-1918 # 800178f0 <log>
    80003076:	854a                	mv	a0,s2
    80003078:	6a8020ef          	jal	80005720 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000307c:	02c92603          	lw	a2,44(s2)
    80003080:	47f5                	li	a5,29
    80003082:	06c7c363          	blt	a5,a2,800030e8 <log_write+0x88>
    80003086:	00015797          	auipc	a5,0x15
    8000308a:	8867a783          	lw	a5,-1914(a5) # 8001790c <log+0x1c>
    8000308e:	37fd                	addiw	a5,a5,-1
    80003090:	04f65c63          	bge	a2,a5,800030e8 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003094:	00015797          	auipc	a5,0x15
    80003098:	87c7a783          	lw	a5,-1924(a5) # 80017910 <log+0x20>
    8000309c:	04f05c63          	blez	a5,800030f4 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800030a0:	4781                	li	a5,0
    800030a2:	04c05f63          	blez	a2,80003100 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800030a6:	44cc                	lw	a1,12(s1)
    800030a8:	00015717          	auipc	a4,0x15
    800030ac:	87870713          	addi	a4,a4,-1928 # 80017920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800030b0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800030b2:	4314                	lw	a3,0(a4)
    800030b4:	04b68663          	beq	a3,a1,80003100 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800030b8:	2785                	addiw	a5,a5,1
    800030ba:	0711                	addi	a4,a4,4
    800030bc:	fef61be3          	bne	a2,a5,800030b2 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800030c0:	0621                	addi	a2,a2,8
    800030c2:	060a                	slli	a2,a2,0x2
    800030c4:	00015797          	auipc	a5,0x15
    800030c8:	82c78793          	addi	a5,a5,-2004 # 800178f0 <log>
    800030cc:	97b2                	add	a5,a5,a2
    800030ce:	44d8                	lw	a4,12(s1)
    800030d0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800030d2:	8526                	mv	a0,s1
    800030d4:	fcbfe0ef          	jal	8000209e <bpin>
    log.lh.n++;
    800030d8:	00015717          	auipc	a4,0x15
    800030dc:	81870713          	addi	a4,a4,-2024 # 800178f0 <log>
    800030e0:	575c                	lw	a5,44(a4)
    800030e2:	2785                	addiw	a5,a5,1
    800030e4:	d75c                	sw	a5,44(a4)
    800030e6:	a80d                	j	80003118 <log_write+0xb8>
    panic("too big a transaction");
    800030e8:	00004517          	auipc	a0,0x4
    800030ec:	42850513          	addi	a0,a0,1064 # 80007510 <etext+0x510>
    800030f0:	302020ef          	jal	800053f2 <panic>
    panic("log_write outside of trans");
    800030f4:	00004517          	auipc	a0,0x4
    800030f8:	43450513          	addi	a0,a0,1076 # 80007528 <etext+0x528>
    800030fc:	2f6020ef          	jal	800053f2 <panic>
  log.lh.block[i] = b->blockno;
    80003100:	00878693          	addi	a3,a5,8
    80003104:	068a                	slli	a3,a3,0x2
    80003106:	00014717          	auipc	a4,0x14
    8000310a:	7ea70713          	addi	a4,a4,2026 # 800178f0 <log>
    8000310e:	9736                	add	a4,a4,a3
    80003110:	44d4                	lw	a3,12(s1)
    80003112:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003114:	faf60fe3          	beq	a2,a5,800030d2 <log_write+0x72>
  }
  release(&log.lock);
    80003118:	00014517          	auipc	a0,0x14
    8000311c:	7d850513          	addi	a0,a0,2008 # 800178f0 <log>
    80003120:	698020ef          	jal	800057b8 <release>
}
    80003124:	60e2                	ld	ra,24(sp)
    80003126:	6442                	ld	s0,16(sp)
    80003128:	64a2                	ld	s1,8(sp)
    8000312a:	6902                	ld	s2,0(sp)
    8000312c:	6105                	addi	sp,sp,32
    8000312e:	8082                	ret

0000000080003130 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003130:	1101                	addi	sp,sp,-32
    80003132:	ec06                	sd	ra,24(sp)
    80003134:	e822                	sd	s0,16(sp)
    80003136:	e426                	sd	s1,8(sp)
    80003138:	e04a                	sd	s2,0(sp)
    8000313a:	1000                	addi	s0,sp,32
    8000313c:	84aa                	mv	s1,a0
    8000313e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003140:	00004597          	auipc	a1,0x4
    80003144:	40858593          	addi	a1,a1,1032 # 80007548 <etext+0x548>
    80003148:	0521                	addi	a0,a0,8
    8000314a:	556020ef          	jal	800056a0 <initlock>
  lk->name = name;
    8000314e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003152:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003156:	0204a423          	sw	zero,40(s1)
}
    8000315a:	60e2                	ld	ra,24(sp)
    8000315c:	6442                	ld	s0,16(sp)
    8000315e:	64a2                	ld	s1,8(sp)
    80003160:	6902                	ld	s2,0(sp)
    80003162:	6105                	addi	sp,sp,32
    80003164:	8082                	ret

0000000080003166 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003166:	1101                	addi	sp,sp,-32
    80003168:	ec06                	sd	ra,24(sp)
    8000316a:	e822                	sd	s0,16(sp)
    8000316c:	e426                	sd	s1,8(sp)
    8000316e:	e04a                	sd	s2,0(sp)
    80003170:	1000                	addi	s0,sp,32
    80003172:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003174:	00850913          	addi	s2,a0,8
    80003178:	854a                	mv	a0,s2
    8000317a:	5a6020ef          	jal	80005720 <acquire>
  while (lk->locked) {
    8000317e:	409c                	lw	a5,0(s1)
    80003180:	c799                	beqz	a5,8000318e <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003182:	85ca                	mv	a1,s2
    80003184:	8526                	mv	a0,s1
    80003186:	9aefe0ef          	jal	80001334 <sleep>
  while (lk->locked) {
    8000318a:	409c                	lw	a5,0(s1)
    8000318c:	fbfd                	bnez	a5,80003182 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000318e:	4785                	li	a5,1
    80003190:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003192:	bd5fd0ef          	jal	80000d66 <myproc>
    80003196:	591c                	lw	a5,48(a0)
    80003198:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000319a:	854a                	mv	a0,s2
    8000319c:	61c020ef          	jal	800057b8 <release>
}
    800031a0:	60e2                	ld	ra,24(sp)
    800031a2:	6442                	ld	s0,16(sp)
    800031a4:	64a2                	ld	s1,8(sp)
    800031a6:	6902                	ld	s2,0(sp)
    800031a8:	6105                	addi	sp,sp,32
    800031aa:	8082                	ret

00000000800031ac <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800031ac:	1101                	addi	sp,sp,-32
    800031ae:	ec06                	sd	ra,24(sp)
    800031b0:	e822                	sd	s0,16(sp)
    800031b2:	e426                	sd	s1,8(sp)
    800031b4:	e04a                	sd	s2,0(sp)
    800031b6:	1000                	addi	s0,sp,32
    800031b8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800031ba:	00850913          	addi	s2,a0,8
    800031be:	854a                	mv	a0,s2
    800031c0:	560020ef          	jal	80005720 <acquire>
  lk->locked = 0;
    800031c4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800031c8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800031cc:	8526                	mv	a0,s1
    800031ce:	9b2fe0ef          	jal	80001380 <wakeup>
  release(&lk->lk);
    800031d2:	854a                	mv	a0,s2
    800031d4:	5e4020ef          	jal	800057b8 <release>
}
    800031d8:	60e2                	ld	ra,24(sp)
    800031da:	6442                	ld	s0,16(sp)
    800031dc:	64a2                	ld	s1,8(sp)
    800031de:	6902                	ld	s2,0(sp)
    800031e0:	6105                	addi	sp,sp,32
    800031e2:	8082                	ret

00000000800031e4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800031e4:	7179                	addi	sp,sp,-48
    800031e6:	f406                	sd	ra,40(sp)
    800031e8:	f022                	sd	s0,32(sp)
    800031ea:	ec26                	sd	s1,24(sp)
    800031ec:	e84a                	sd	s2,16(sp)
    800031ee:	1800                	addi	s0,sp,48
    800031f0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800031f2:	00850913          	addi	s2,a0,8
    800031f6:	854a                	mv	a0,s2
    800031f8:	528020ef          	jal	80005720 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800031fc:	409c                	lw	a5,0(s1)
    800031fe:	ef81                	bnez	a5,80003216 <holdingsleep+0x32>
    80003200:	4481                	li	s1,0
  release(&lk->lk);
    80003202:	854a                	mv	a0,s2
    80003204:	5b4020ef          	jal	800057b8 <release>
  return r;
}
    80003208:	8526                	mv	a0,s1
    8000320a:	70a2                	ld	ra,40(sp)
    8000320c:	7402                	ld	s0,32(sp)
    8000320e:	64e2                	ld	s1,24(sp)
    80003210:	6942                	ld	s2,16(sp)
    80003212:	6145                	addi	sp,sp,48
    80003214:	8082                	ret
    80003216:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003218:	0284a983          	lw	s3,40(s1)
    8000321c:	b4bfd0ef          	jal	80000d66 <myproc>
    80003220:	5904                	lw	s1,48(a0)
    80003222:	413484b3          	sub	s1,s1,s3
    80003226:	0014b493          	seqz	s1,s1
    8000322a:	69a2                	ld	s3,8(sp)
    8000322c:	bfd9                	j	80003202 <holdingsleep+0x1e>

000000008000322e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000322e:	1141                	addi	sp,sp,-16
    80003230:	e406                	sd	ra,8(sp)
    80003232:	e022                	sd	s0,0(sp)
    80003234:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003236:	00004597          	auipc	a1,0x4
    8000323a:	32258593          	addi	a1,a1,802 # 80007558 <etext+0x558>
    8000323e:	00014517          	auipc	a0,0x14
    80003242:	7fa50513          	addi	a0,a0,2042 # 80017a38 <ftable>
    80003246:	45a020ef          	jal	800056a0 <initlock>
}
    8000324a:	60a2                	ld	ra,8(sp)
    8000324c:	6402                	ld	s0,0(sp)
    8000324e:	0141                	addi	sp,sp,16
    80003250:	8082                	ret

0000000080003252 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003252:	1101                	addi	sp,sp,-32
    80003254:	ec06                	sd	ra,24(sp)
    80003256:	e822                	sd	s0,16(sp)
    80003258:	e426                	sd	s1,8(sp)
    8000325a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000325c:	00014517          	auipc	a0,0x14
    80003260:	7dc50513          	addi	a0,a0,2012 # 80017a38 <ftable>
    80003264:	4bc020ef          	jal	80005720 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003268:	00014497          	auipc	s1,0x14
    8000326c:	7e848493          	addi	s1,s1,2024 # 80017a50 <ftable+0x18>
    80003270:	00015717          	auipc	a4,0x15
    80003274:	78070713          	addi	a4,a4,1920 # 800189f0 <disk>
    if(f->ref == 0){
    80003278:	40dc                	lw	a5,4(s1)
    8000327a:	cf89                	beqz	a5,80003294 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000327c:	02848493          	addi	s1,s1,40
    80003280:	fee49ce3          	bne	s1,a4,80003278 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003284:	00014517          	auipc	a0,0x14
    80003288:	7b450513          	addi	a0,a0,1972 # 80017a38 <ftable>
    8000328c:	52c020ef          	jal	800057b8 <release>
  return 0;
    80003290:	4481                	li	s1,0
    80003292:	a809                	j	800032a4 <filealloc+0x52>
      f->ref = 1;
    80003294:	4785                	li	a5,1
    80003296:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003298:	00014517          	auipc	a0,0x14
    8000329c:	7a050513          	addi	a0,a0,1952 # 80017a38 <ftable>
    800032a0:	518020ef          	jal	800057b8 <release>
}
    800032a4:	8526                	mv	a0,s1
    800032a6:	60e2                	ld	ra,24(sp)
    800032a8:	6442                	ld	s0,16(sp)
    800032aa:	64a2                	ld	s1,8(sp)
    800032ac:	6105                	addi	sp,sp,32
    800032ae:	8082                	ret

00000000800032b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800032b0:	1101                	addi	sp,sp,-32
    800032b2:	ec06                	sd	ra,24(sp)
    800032b4:	e822                	sd	s0,16(sp)
    800032b6:	e426                	sd	s1,8(sp)
    800032b8:	1000                	addi	s0,sp,32
    800032ba:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800032bc:	00014517          	auipc	a0,0x14
    800032c0:	77c50513          	addi	a0,a0,1916 # 80017a38 <ftable>
    800032c4:	45c020ef          	jal	80005720 <acquire>
  if(f->ref < 1)
    800032c8:	40dc                	lw	a5,4(s1)
    800032ca:	02f05063          	blez	a5,800032ea <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800032ce:	2785                	addiw	a5,a5,1
    800032d0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800032d2:	00014517          	auipc	a0,0x14
    800032d6:	76650513          	addi	a0,a0,1894 # 80017a38 <ftable>
    800032da:	4de020ef          	jal	800057b8 <release>
  return f;
}
    800032de:	8526                	mv	a0,s1
    800032e0:	60e2                	ld	ra,24(sp)
    800032e2:	6442                	ld	s0,16(sp)
    800032e4:	64a2                	ld	s1,8(sp)
    800032e6:	6105                	addi	sp,sp,32
    800032e8:	8082                	ret
    panic("filedup");
    800032ea:	00004517          	auipc	a0,0x4
    800032ee:	27650513          	addi	a0,a0,630 # 80007560 <etext+0x560>
    800032f2:	100020ef          	jal	800053f2 <panic>

00000000800032f6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800032f6:	7139                	addi	sp,sp,-64
    800032f8:	fc06                	sd	ra,56(sp)
    800032fa:	f822                	sd	s0,48(sp)
    800032fc:	f426                	sd	s1,40(sp)
    800032fe:	0080                	addi	s0,sp,64
    80003300:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003302:	00014517          	auipc	a0,0x14
    80003306:	73650513          	addi	a0,a0,1846 # 80017a38 <ftable>
    8000330a:	416020ef          	jal	80005720 <acquire>
  if(f->ref < 1)
    8000330e:	40dc                	lw	a5,4(s1)
    80003310:	04f05a63          	blez	a5,80003364 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003314:	37fd                	addiw	a5,a5,-1
    80003316:	0007871b          	sext.w	a4,a5
    8000331a:	c0dc                	sw	a5,4(s1)
    8000331c:	04e04e63          	bgtz	a4,80003378 <fileclose+0x82>
    80003320:	f04a                	sd	s2,32(sp)
    80003322:	ec4e                	sd	s3,24(sp)
    80003324:	e852                	sd	s4,16(sp)
    80003326:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003328:	0004a903          	lw	s2,0(s1)
    8000332c:	0094ca83          	lbu	s5,9(s1)
    80003330:	0104ba03          	ld	s4,16(s1)
    80003334:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003338:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000333c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003340:	00014517          	auipc	a0,0x14
    80003344:	6f850513          	addi	a0,a0,1784 # 80017a38 <ftable>
    80003348:	470020ef          	jal	800057b8 <release>

  if(ff.type == FD_PIPE){
    8000334c:	4785                	li	a5,1
    8000334e:	04f90063          	beq	s2,a5,8000338e <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003352:	3979                	addiw	s2,s2,-2
    80003354:	4785                	li	a5,1
    80003356:	0527f563          	bgeu	a5,s2,800033a0 <fileclose+0xaa>
    8000335a:	7902                	ld	s2,32(sp)
    8000335c:	69e2                	ld	s3,24(sp)
    8000335e:	6a42                	ld	s4,16(sp)
    80003360:	6aa2                	ld	s5,8(sp)
    80003362:	a00d                	j	80003384 <fileclose+0x8e>
    80003364:	f04a                	sd	s2,32(sp)
    80003366:	ec4e                	sd	s3,24(sp)
    80003368:	e852                	sd	s4,16(sp)
    8000336a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000336c:	00004517          	auipc	a0,0x4
    80003370:	1fc50513          	addi	a0,a0,508 # 80007568 <etext+0x568>
    80003374:	07e020ef          	jal	800053f2 <panic>
    release(&ftable.lock);
    80003378:	00014517          	auipc	a0,0x14
    8000337c:	6c050513          	addi	a0,a0,1728 # 80017a38 <ftable>
    80003380:	438020ef          	jal	800057b8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003384:	70e2                	ld	ra,56(sp)
    80003386:	7442                	ld	s0,48(sp)
    80003388:	74a2                	ld	s1,40(sp)
    8000338a:	6121                	addi	sp,sp,64
    8000338c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000338e:	85d6                	mv	a1,s5
    80003390:	8552                	mv	a0,s4
    80003392:	336000ef          	jal	800036c8 <pipeclose>
    80003396:	7902                	ld	s2,32(sp)
    80003398:	69e2                	ld	s3,24(sp)
    8000339a:	6a42                	ld	s4,16(sp)
    8000339c:	6aa2                	ld	s5,8(sp)
    8000339e:	b7dd                	j	80003384 <fileclose+0x8e>
    begin_op();
    800033a0:	b3dff0ef          	jal	80002edc <begin_op>
    iput(ff.ip);
    800033a4:	854e                	mv	a0,s3
    800033a6:	c22ff0ef          	jal	800027c8 <iput>
    end_op();
    800033aa:	b9dff0ef          	jal	80002f46 <end_op>
    800033ae:	7902                	ld	s2,32(sp)
    800033b0:	69e2                	ld	s3,24(sp)
    800033b2:	6a42                	ld	s4,16(sp)
    800033b4:	6aa2                	ld	s5,8(sp)
    800033b6:	b7f9                	j	80003384 <fileclose+0x8e>

00000000800033b8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800033b8:	715d                	addi	sp,sp,-80
    800033ba:	e486                	sd	ra,72(sp)
    800033bc:	e0a2                	sd	s0,64(sp)
    800033be:	fc26                	sd	s1,56(sp)
    800033c0:	f44e                	sd	s3,40(sp)
    800033c2:	0880                	addi	s0,sp,80
    800033c4:	84aa                	mv	s1,a0
    800033c6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800033c8:	99ffd0ef          	jal	80000d66 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800033cc:	409c                	lw	a5,0(s1)
    800033ce:	37f9                	addiw	a5,a5,-2
    800033d0:	4705                	li	a4,1
    800033d2:	04f76063          	bltu	a4,a5,80003412 <filestat+0x5a>
    800033d6:	f84a                	sd	s2,48(sp)
    800033d8:	892a                	mv	s2,a0
    ilock(f->ip);
    800033da:	6c88                	ld	a0,24(s1)
    800033dc:	a6aff0ef          	jal	80002646 <ilock>
    stati(f->ip, &st);
    800033e0:	fb840593          	addi	a1,s0,-72
    800033e4:	6c88                	ld	a0,24(s1)
    800033e6:	c8aff0ef          	jal	80002870 <stati>
    iunlock(f->ip);
    800033ea:	6c88                	ld	a0,24(s1)
    800033ec:	b08ff0ef          	jal	800026f4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800033f0:	46e1                	li	a3,24
    800033f2:	fb840613          	addi	a2,s0,-72
    800033f6:	85ce                	mv	a1,s3
    800033f8:	05093503          	ld	a0,80(s2)
    800033fc:	ddcfd0ef          	jal	800009d8 <copyout>
    80003400:	41f5551b          	sraiw	a0,a0,0x1f
    80003404:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003406:	60a6                	ld	ra,72(sp)
    80003408:	6406                	ld	s0,64(sp)
    8000340a:	74e2                	ld	s1,56(sp)
    8000340c:	79a2                	ld	s3,40(sp)
    8000340e:	6161                	addi	sp,sp,80
    80003410:	8082                	ret
  return -1;
    80003412:	557d                	li	a0,-1
    80003414:	bfcd                	j	80003406 <filestat+0x4e>

0000000080003416 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003416:	7179                	addi	sp,sp,-48
    80003418:	f406                	sd	ra,40(sp)
    8000341a:	f022                	sd	s0,32(sp)
    8000341c:	e84a                	sd	s2,16(sp)
    8000341e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003420:	00854783          	lbu	a5,8(a0)
    80003424:	cfd1                	beqz	a5,800034c0 <fileread+0xaa>
    80003426:	ec26                	sd	s1,24(sp)
    80003428:	e44e                	sd	s3,8(sp)
    8000342a:	84aa                	mv	s1,a0
    8000342c:	89ae                	mv	s3,a1
    8000342e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003430:	411c                	lw	a5,0(a0)
    80003432:	4705                	li	a4,1
    80003434:	04e78363          	beq	a5,a4,8000347a <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003438:	470d                	li	a4,3
    8000343a:	04e78763          	beq	a5,a4,80003488 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000343e:	4709                	li	a4,2
    80003440:	06e79a63          	bne	a5,a4,800034b4 <fileread+0x9e>
    ilock(f->ip);
    80003444:	6d08                	ld	a0,24(a0)
    80003446:	a00ff0ef          	jal	80002646 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000344a:	874a                	mv	a4,s2
    8000344c:	5094                	lw	a3,32(s1)
    8000344e:	864e                	mv	a2,s3
    80003450:	4585                	li	a1,1
    80003452:	6c88                	ld	a0,24(s1)
    80003454:	c46ff0ef          	jal	8000289a <readi>
    80003458:	892a                	mv	s2,a0
    8000345a:	00a05563          	blez	a0,80003464 <fileread+0x4e>
      f->off += r;
    8000345e:	509c                	lw	a5,32(s1)
    80003460:	9fa9                	addw	a5,a5,a0
    80003462:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003464:	6c88                	ld	a0,24(s1)
    80003466:	a8eff0ef          	jal	800026f4 <iunlock>
    8000346a:	64e2                	ld	s1,24(sp)
    8000346c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000346e:	854a                	mv	a0,s2
    80003470:	70a2                	ld	ra,40(sp)
    80003472:	7402                	ld	s0,32(sp)
    80003474:	6942                	ld	s2,16(sp)
    80003476:	6145                	addi	sp,sp,48
    80003478:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000347a:	6908                	ld	a0,16(a0)
    8000347c:	388000ef          	jal	80003804 <piperead>
    80003480:	892a                	mv	s2,a0
    80003482:	64e2                	ld	s1,24(sp)
    80003484:	69a2                	ld	s3,8(sp)
    80003486:	b7e5                	j	8000346e <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003488:	02451783          	lh	a5,36(a0)
    8000348c:	03079693          	slli	a3,a5,0x30
    80003490:	92c1                	srli	a3,a3,0x30
    80003492:	4725                	li	a4,9
    80003494:	02d76863          	bltu	a4,a3,800034c4 <fileread+0xae>
    80003498:	0792                	slli	a5,a5,0x4
    8000349a:	00014717          	auipc	a4,0x14
    8000349e:	4fe70713          	addi	a4,a4,1278 # 80017998 <devsw>
    800034a2:	97ba                	add	a5,a5,a4
    800034a4:	639c                	ld	a5,0(a5)
    800034a6:	c39d                	beqz	a5,800034cc <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800034a8:	4505                	li	a0,1
    800034aa:	9782                	jalr	a5
    800034ac:	892a                	mv	s2,a0
    800034ae:	64e2                	ld	s1,24(sp)
    800034b0:	69a2                	ld	s3,8(sp)
    800034b2:	bf75                	j	8000346e <fileread+0x58>
    panic("fileread");
    800034b4:	00004517          	auipc	a0,0x4
    800034b8:	0c450513          	addi	a0,a0,196 # 80007578 <etext+0x578>
    800034bc:	737010ef          	jal	800053f2 <panic>
    return -1;
    800034c0:	597d                	li	s2,-1
    800034c2:	b775                	j	8000346e <fileread+0x58>
      return -1;
    800034c4:	597d                	li	s2,-1
    800034c6:	64e2                	ld	s1,24(sp)
    800034c8:	69a2                	ld	s3,8(sp)
    800034ca:	b755                	j	8000346e <fileread+0x58>
    800034cc:	597d                	li	s2,-1
    800034ce:	64e2                	ld	s1,24(sp)
    800034d0:	69a2                	ld	s3,8(sp)
    800034d2:	bf71                	j	8000346e <fileread+0x58>

00000000800034d4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800034d4:	00954783          	lbu	a5,9(a0)
    800034d8:	10078b63          	beqz	a5,800035ee <filewrite+0x11a>
{
    800034dc:	715d                	addi	sp,sp,-80
    800034de:	e486                	sd	ra,72(sp)
    800034e0:	e0a2                	sd	s0,64(sp)
    800034e2:	f84a                	sd	s2,48(sp)
    800034e4:	f052                	sd	s4,32(sp)
    800034e6:	e85a                	sd	s6,16(sp)
    800034e8:	0880                	addi	s0,sp,80
    800034ea:	892a                	mv	s2,a0
    800034ec:	8b2e                	mv	s6,a1
    800034ee:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800034f0:	411c                	lw	a5,0(a0)
    800034f2:	4705                	li	a4,1
    800034f4:	02e78763          	beq	a5,a4,80003522 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034f8:	470d                	li	a4,3
    800034fa:	02e78863          	beq	a5,a4,8000352a <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800034fe:	4709                	li	a4,2
    80003500:	0ce79c63          	bne	a5,a4,800035d8 <filewrite+0x104>
    80003504:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003506:	0ac05863          	blez	a2,800035b6 <filewrite+0xe2>
    8000350a:	fc26                	sd	s1,56(sp)
    8000350c:	ec56                	sd	s5,24(sp)
    8000350e:	e45e                	sd	s7,8(sp)
    80003510:	e062                	sd	s8,0(sp)
    int i = 0;
    80003512:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003514:	6b85                	lui	s7,0x1
    80003516:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000351a:	6c05                	lui	s8,0x1
    8000351c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003520:	a8b5                	j	8000359c <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003522:	6908                	ld	a0,16(a0)
    80003524:	1fc000ef          	jal	80003720 <pipewrite>
    80003528:	a04d                	j	800035ca <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000352a:	02451783          	lh	a5,36(a0)
    8000352e:	03079693          	slli	a3,a5,0x30
    80003532:	92c1                	srli	a3,a3,0x30
    80003534:	4725                	li	a4,9
    80003536:	0ad76e63          	bltu	a4,a3,800035f2 <filewrite+0x11e>
    8000353a:	0792                	slli	a5,a5,0x4
    8000353c:	00014717          	auipc	a4,0x14
    80003540:	45c70713          	addi	a4,a4,1116 # 80017998 <devsw>
    80003544:	97ba                	add	a5,a5,a4
    80003546:	679c                	ld	a5,8(a5)
    80003548:	c7dd                	beqz	a5,800035f6 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000354a:	4505                	li	a0,1
    8000354c:	9782                	jalr	a5
    8000354e:	a8b5                	j	800035ca <filewrite+0xf6>
      if(n1 > max)
    80003550:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003554:	989ff0ef          	jal	80002edc <begin_op>
      ilock(f->ip);
    80003558:	01893503          	ld	a0,24(s2)
    8000355c:	8eaff0ef          	jal	80002646 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003560:	8756                	mv	a4,s5
    80003562:	02092683          	lw	a3,32(s2)
    80003566:	01698633          	add	a2,s3,s6
    8000356a:	4585                	li	a1,1
    8000356c:	01893503          	ld	a0,24(s2)
    80003570:	c26ff0ef          	jal	80002996 <writei>
    80003574:	84aa                	mv	s1,a0
    80003576:	00a05763          	blez	a0,80003584 <filewrite+0xb0>
        f->off += r;
    8000357a:	02092783          	lw	a5,32(s2)
    8000357e:	9fa9                	addw	a5,a5,a0
    80003580:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003584:	01893503          	ld	a0,24(s2)
    80003588:	96cff0ef          	jal	800026f4 <iunlock>
      end_op();
    8000358c:	9bbff0ef          	jal	80002f46 <end_op>

      if(r != n1){
    80003590:	029a9563          	bne	s5,s1,800035ba <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003594:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003598:	0149da63          	bge	s3,s4,800035ac <filewrite+0xd8>
      int n1 = n - i;
    8000359c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800035a0:	0004879b          	sext.w	a5,s1
    800035a4:	fafbd6e3          	bge	s7,a5,80003550 <filewrite+0x7c>
    800035a8:	84e2                	mv	s1,s8
    800035aa:	b75d                	j	80003550 <filewrite+0x7c>
    800035ac:	74e2                	ld	s1,56(sp)
    800035ae:	6ae2                	ld	s5,24(sp)
    800035b0:	6ba2                	ld	s7,8(sp)
    800035b2:	6c02                	ld	s8,0(sp)
    800035b4:	a039                	j	800035c2 <filewrite+0xee>
    int i = 0;
    800035b6:	4981                	li	s3,0
    800035b8:	a029                	j	800035c2 <filewrite+0xee>
    800035ba:	74e2                	ld	s1,56(sp)
    800035bc:	6ae2                	ld	s5,24(sp)
    800035be:	6ba2                	ld	s7,8(sp)
    800035c0:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800035c2:	033a1c63          	bne	s4,s3,800035fa <filewrite+0x126>
    800035c6:	8552                	mv	a0,s4
    800035c8:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800035ca:	60a6                	ld	ra,72(sp)
    800035cc:	6406                	ld	s0,64(sp)
    800035ce:	7942                	ld	s2,48(sp)
    800035d0:	7a02                	ld	s4,32(sp)
    800035d2:	6b42                	ld	s6,16(sp)
    800035d4:	6161                	addi	sp,sp,80
    800035d6:	8082                	ret
    800035d8:	fc26                	sd	s1,56(sp)
    800035da:	f44e                	sd	s3,40(sp)
    800035dc:	ec56                	sd	s5,24(sp)
    800035de:	e45e                	sd	s7,8(sp)
    800035e0:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800035e2:	00004517          	auipc	a0,0x4
    800035e6:	fa650513          	addi	a0,a0,-90 # 80007588 <etext+0x588>
    800035ea:	609010ef          	jal	800053f2 <panic>
    return -1;
    800035ee:	557d                	li	a0,-1
}
    800035f0:	8082                	ret
      return -1;
    800035f2:	557d                	li	a0,-1
    800035f4:	bfd9                	j	800035ca <filewrite+0xf6>
    800035f6:	557d                	li	a0,-1
    800035f8:	bfc9                	j	800035ca <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800035fa:	557d                	li	a0,-1
    800035fc:	79a2                	ld	s3,40(sp)
    800035fe:	b7f1                	j	800035ca <filewrite+0xf6>

0000000080003600 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003600:	7179                	addi	sp,sp,-48
    80003602:	f406                	sd	ra,40(sp)
    80003604:	f022                	sd	s0,32(sp)
    80003606:	ec26                	sd	s1,24(sp)
    80003608:	e052                	sd	s4,0(sp)
    8000360a:	1800                	addi	s0,sp,48
    8000360c:	84aa                	mv	s1,a0
    8000360e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003610:	0005b023          	sd	zero,0(a1)
    80003614:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003618:	c3bff0ef          	jal	80003252 <filealloc>
    8000361c:	e088                	sd	a0,0(s1)
    8000361e:	c549                	beqz	a0,800036a8 <pipealloc+0xa8>
    80003620:	c33ff0ef          	jal	80003252 <filealloc>
    80003624:	00aa3023          	sd	a0,0(s4)
    80003628:	cd25                	beqz	a0,800036a0 <pipealloc+0xa0>
    8000362a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000362c:	ad3fc0ef          	jal	800000fe <kalloc>
    80003630:	892a                	mv	s2,a0
    80003632:	c12d                	beqz	a0,80003694 <pipealloc+0x94>
    80003634:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003636:	4985                	li	s3,1
    80003638:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000363c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003640:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003644:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003648:	00004597          	auipc	a1,0x4
    8000364c:	f5058593          	addi	a1,a1,-176 # 80007598 <etext+0x598>
    80003650:	050020ef          	jal	800056a0 <initlock>
  (*f0)->type = FD_PIPE;
    80003654:	609c                	ld	a5,0(s1)
    80003656:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000365a:	609c                	ld	a5,0(s1)
    8000365c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003660:	609c                	ld	a5,0(s1)
    80003662:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003666:	609c                	ld	a5,0(s1)
    80003668:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000366c:	000a3783          	ld	a5,0(s4)
    80003670:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003674:	000a3783          	ld	a5,0(s4)
    80003678:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000367c:	000a3783          	ld	a5,0(s4)
    80003680:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003684:	000a3783          	ld	a5,0(s4)
    80003688:	0127b823          	sd	s2,16(a5)
  return 0;
    8000368c:	4501                	li	a0,0
    8000368e:	6942                	ld	s2,16(sp)
    80003690:	69a2                	ld	s3,8(sp)
    80003692:	a01d                	j	800036b8 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003694:	6088                	ld	a0,0(s1)
    80003696:	c119                	beqz	a0,8000369c <pipealloc+0x9c>
    80003698:	6942                	ld	s2,16(sp)
    8000369a:	a029                	j	800036a4 <pipealloc+0xa4>
    8000369c:	6942                	ld	s2,16(sp)
    8000369e:	a029                	j	800036a8 <pipealloc+0xa8>
    800036a0:	6088                	ld	a0,0(s1)
    800036a2:	c10d                	beqz	a0,800036c4 <pipealloc+0xc4>
    fileclose(*f0);
    800036a4:	c53ff0ef          	jal	800032f6 <fileclose>
  if(*f1)
    800036a8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800036ac:	557d                	li	a0,-1
  if(*f1)
    800036ae:	c789                	beqz	a5,800036b8 <pipealloc+0xb8>
    fileclose(*f1);
    800036b0:	853e                	mv	a0,a5
    800036b2:	c45ff0ef          	jal	800032f6 <fileclose>
  return -1;
    800036b6:	557d                	li	a0,-1
}
    800036b8:	70a2                	ld	ra,40(sp)
    800036ba:	7402                	ld	s0,32(sp)
    800036bc:	64e2                	ld	s1,24(sp)
    800036be:	6a02                	ld	s4,0(sp)
    800036c0:	6145                	addi	sp,sp,48
    800036c2:	8082                	ret
  return -1;
    800036c4:	557d                	li	a0,-1
    800036c6:	bfcd                	j	800036b8 <pipealloc+0xb8>

00000000800036c8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800036c8:	1101                	addi	sp,sp,-32
    800036ca:	ec06                	sd	ra,24(sp)
    800036cc:	e822                	sd	s0,16(sp)
    800036ce:	e426                	sd	s1,8(sp)
    800036d0:	e04a                	sd	s2,0(sp)
    800036d2:	1000                	addi	s0,sp,32
    800036d4:	84aa                	mv	s1,a0
    800036d6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800036d8:	048020ef          	jal	80005720 <acquire>
  if(writable){
    800036dc:	02090763          	beqz	s2,8000370a <pipeclose+0x42>
    pi->writeopen = 0;
    800036e0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800036e4:	21848513          	addi	a0,s1,536
    800036e8:	c99fd0ef          	jal	80001380 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800036ec:	2204b783          	ld	a5,544(s1)
    800036f0:	e785                	bnez	a5,80003718 <pipeclose+0x50>
    release(&pi->lock);
    800036f2:	8526                	mv	a0,s1
    800036f4:	0c4020ef          	jal	800057b8 <release>
    kfree((char*)pi);
    800036f8:	8526                	mv	a0,s1
    800036fa:	923fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800036fe:	60e2                	ld	ra,24(sp)
    80003700:	6442                	ld	s0,16(sp)
    80003702:	64a2                	ld	s1,8(sp)
    80003704:	6902                	ld	s2,0(sp)
    80003706:	6105                	addi	sp,sp,32
    80003708:	8082                	ret
    pi->readopen = 0;
    8000370a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000370e:	21c48513          	addi	a0,s1,540
    80003712:	c6ffd0ef          	jal	80001380 <wakeup>
    80003716:	bfd9                	j	800036ec <pipeclose+0x24>
    release(&pi->lock);
    80003718:	8526                	mv	a0,s1
    8000371a:	09e020ef          	jal	800057b8 <release>
}
    8000371e:	b7c5                	j	800036fe <pipeclose+0x36>

0000000080003720 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003720:	711d                	addi	sp,sp,-96
    80003722:	ec86                	sd	ra,88(sp)
    80003724:	e8a2                	sd	s0,80(sp)
    80003726:	e4a6                	sd	s1,72(sp)
    80003728:	e0ca                	sd	s2,64(sp)
    8000372a:	fc4e                	sd	s3,56(sp)
    8000372c:	f852                	sd	s4,48(sp)
    8000372e:	f456                	sd	s5,40(sp)
    80003730:	1080                	addi	s0,sp,96
    80003732:	84aa                	mv	s1,a0
    80003734:	8aae                	mv	s5,a1
    80003736:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003738:	e2efd0ef          	jal	80000d66 <myproc>
    8000373c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000373e:	8526                	mv	a0,s1
    80003740:	7e1010ef          	jal	80005720 <acquire>
  while(i < n){
    80003744:	0b405a63          	blez	s4,800037f8 <pipewrite+0xd8>
    80003748:	f05a                	sd	s6,32(sp)
    8000374a:	ec5e                	sd	s7,24(sp)
    8000374c:	e862                	sd	s8,16(sp)
  int i = 0;
    8000374e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003750:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003752:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003756:	21c48b93          	addi	s7,s1,540
    8000375a:	a81d                	j	80003790 <pipewrite+0x70>
      release(&pi->lock);
    8000375c:	8526                	mv	a0,s1
    8000375e:	05a020ef          	jal	800057b8 <release>
      return -1;
    80003762:	597d                	li	s2,-1
    80003764:	7b02                	ld	s6,32(sp)
    80003766:	6be2                	ld	s7,24(sp)
    80003768:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000376a:	854a                	mv	a0,s2
    8000376c:	60e6                	ld	ra,88(sp)
    8000376e:	6446                	ld	s0,80(sp)
    80003770:	64a6                	ld	s1,72(sp)
    80003772:	6906                	ld	s2,64(sp)
    80003774:	79e2                	ld	s3,56(sp)
    80003776:	7a42                	ld	s4,48(sp)
    80003778:	7aa2                	ld	s5,40(sp)
    8000377a:	6125                	addi	sp,sp,96
    8000377c:	8082                	ret
      wakeup(&pi->nread);
    8000377e:	8562                	mv	a0,s8
    80003780:	c01fd0ef          	jal	80001380 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003784:	85a6                	mv	a1,s1
    80003786:	855e                	mv	a0,s7
    80003788:	badfd0ef          	jal	80001334 <sleep>
  while(i < n){
    8000378c:	05495b63          	bge	s2,s4,800037e2 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003790:	2204a783          	lw	a5,544(s1)
    80003794:	d7e1                	beqz	a5,8000375c <pipewrite+0x3c>
    80003796:	854e                	mv	a0,s3
    80003798:	dd5fd0ef          	jal	8000156c <killed>
    8000379c:	f161                	bnez	a0,8000375c <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000379e:	2184a783          	lw	a5,536(s1)
    800037a2:	21c4a703          	lw	a4,540(s1)
    800037a6:	2007879b          	addiw	a5,a5,512
    800037aa:	fcf70ae3          	beq	a4,a5,8000377e <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800037ae:	4685                	li	a3,1
    800037b0:	01590633          	add	a2,s2,s5
    800037b4:	faf40593          	addi	a1,s0,-81
    800037b8:	0509b503          	ld	a0,80(s3)
    800037bc:	af2fd0ef          	jal	80000aae <copyin>
    800037c0:	03650e63          	beq	a0,s6,800037fc <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800037c4:	21c4a783          	lw	a5,540(s1)
    800037c8:	0017871b          	addiw	a4,a5,1
    800037cc:	20e4ae23          	sw	a4,540(s1)
    800037d0:	1ff7f793          	andi	a5,a5,511
    800037d4:	97a6                	add	a5,a5,s1
    800037d6:	faf44703          	lbu	a4,-81(s0)
    800037da:	00e78c23          	sb	a4,24(a5)
      i++;
    800037de:	2905                	addiw	s2,s2,1
    800037e0:	b775                	j	8000378c <pipewrite+0x6c>
    800037e2:	7b02                	ld	s6,32(sp)
    800037e4:	6be2                	ld	s7,24(sp)
    800037e6:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800037e8:	21848513          	addi	a0,s1,536
    800037ec:	b95fd0ef          	jal	80001380 <wakeup>
  release(&pi->lock);
    800037f0:	8526                	mv	a0,s1
    800037f2:	7c7010ef          	jal	800057b8 <release>
  return i;
    800037f6:	bf95                	j	8000376a <pipewrite+0x4a>
  int i = 0;
    800037f8:	4901                	li	s2,0
    800037fa:	b7fd                	j	800037e8 <pipewrite+0xc8>
    800037fc:	7b02                	ld	s6,32(sp)
    800037fe:	6be2                	ld	s7,24(sp)
    80003800:	6c42                	ld	s8,16(sp)
    80003802:	b7dd                	j	800037e8 <pipewrite+0xc8>

0000000080003804 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003804:	715d                	addi	sp,sp,-80
    80003806:	e486                	sd	ra,72(sp)
    80003808:	e0a2                	sd	s0,64(sp)
    8000380a:	fc26                	sd	s1,56(sp)
    8000380c:	f84a                	sd	s2,48(sp)
    8000380e:	f44e                	sd	s3,40(sp)
    80003810:	f052                	sd	s4,32(sp)
    80003812:	ec56                	sd	s5,24(sp)
    80003814:	0880                	addi	s0,sp,80
    80003816:	84aa                	mv	s1,a0
    80003818:	892e                	mv	s2,a1
    8000381a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000381c:	d4afd0ef          	jal	80000d66 <myproc>
    80003820:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003822:	8526                	mv	a0,s1
    80003824:	6fd010ef          	jal	80005720 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003828:	2184a703          	lw	a4,536(s1)
    8000382c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003830:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003834:	02f71563          	bne	a4,a5,8000385e <piperead+0x5a>
    80003838:	2244a783          	lw	a5,548(s1)
    8000383c:	cb85                	beqz	a5,8000386c <piperead+0x68>
    if(killed(pr)){
    8000383e:	8552                	mv	a0,s4
    80003840:	d2dfd0ef          	jal	8000156c <killed>
    80003844:	ed19                	bnez	a0,80003862 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003846:	85a6                	mv	a1,s1
    80003848:	854e                	mv	a0,s3
    8000384a:	aebfd0ef          	jal	80001334 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000384e:	2184a703          	lw	a4,536(s1)
    80003852:	21c4a783          	lw	a5,540(s1)
    80003856:	fef701e3          	beq	a4,a5,80003838 <piperead+0x34>
    8000385a:	e85a                	sd	s6,16(sp)
    8000385c:	a809                	j	8000386e <piperead+0x6a>
    8000385e:	e85a                	sd	s6,16(sp)
    80003860:	a039                	j	8000386e <piperead+0x6a>
      release(&pi->lock);
    80003862:	8526                	mv	a0,s1
    80003864:	755010ef          	jal	800057b8 <release>
      return -1;
    80003868:	59fd                	li	s3,-1
    8000386a:	a8b1                	j	800038c6 <piperead+0xc2>
    8000386c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000386e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003870:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003872:	05505263          	blez	s5,800038b6 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003876:	2184a783          	lw	a5,536(s1)
    8000387a:	21c4a703          	lw	a4,540(s1)
    8000387e:	02f70c63          	beq	a4,a5,800038b6 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003882:	0017871b          	addiw	a4,a5,1
    80003886:	20e4ac23          	sw	a4,536(s1)
    8000388a:	1ff7f793          	andi	a5,a5,511
    8000388e:	97a6                	add	a5,a5,s1
    80003890:	0187c783          	lbu	a5,24(a5)
    80003894:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003898:	4685                	li	a3,1
    8000389a:	fbf40613          	addi	a2,s0,-65
    8000389e:	85ca                	mv	a1,s2
    800038a0:	050a3503          	ld	a0,80(s4)
    800038a4:	934fd0ef          	jal	800009d8 <copyout>
    800038a8:	01650763          	beq	a0,s6,800038b6 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800038ac:	2985                	addiw	s3,s3,1
    800038ae:	0905                	addi	s2,s2,1
    800038b0:	fd3a93e3          	bne	s5,s3,80003876 <piperead+0x72>
    800038b4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800038b6:	21c48513          	addi	a0,s1,540
    800038ba:	ac7fd0ef          	jal	80001380 <wakeup>
  release(&pi->lock);
    800038be:	8526                	mv	a0,s1
    800038c0:	6f9010ef          	jal	800057b8 <release>
    800038c4:	6b42                	ld	s6,16(sp)
  return i;
}
    800038c6:	854e                	mv	a0,s3
    800038c8:	60a6                	ld	ra,72(sp)
    800038ca:	6406                	ld	s0,64(sp)
    800038cc:	74e2                	ld	s1,56(sp)
    800038ce:	7942                	ld	s2,48(sp)
    800038d0:	79a2                	ld	s3,40(sp)
    800038d2:	7a02                	ld	s4,32(sp)
    800038d4:	6ae2                	ld	s5,24(sp)
    800038d6:	6161                	addi	sp,sp,80
    800038d8:	8082                	ret

00000000800038da <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800038da:	1141                	addi	sp,sp,-16
    800038dc:	e422                	sd	s0,8(sp)
    800038de:	0800                	addi	s0,sp,16
    800038e0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800038e2:	8905                	andi	a0,a0,1
    800038e4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800038e6:	8b89                	andi	a5,a5,2
    800038e8:	c399                	beqz	a5,800038ee <flags2perm+0x14>
      perm |= PTE_W;
    800038ea:	00456513          	ori	a0,a0,4
    return perm;
}
    800038ee:	6422                	ld	s0,8(sp)
    800038f0:	0141                	addi	sp,sp,16
    800038f2:	8082                	ret

00000000800038f4 <exec>:

int
exec(char *path, char **argv)
{
    800038f4:	df010113          	addi	sp,sp,-528
    800038f8:	20113423          	sd	ra,520(sp)
    800038fc:	20813023          	sd	s0,512(sp)
    80003900:	ffa6                	sd	s1,504(sp)
    80003902:	fbca                	sd	s2,496(sp)
    80003904:	0c00                	addi	s0,sp,528
    80003906:	892a                	mv	s2,a0
    80003908:	dea43c23          	sd	a0,-520(s0)
    8000390c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003910:	c56fd0ef          	jal	80000d66 <myproc>
    80003914:	84aa                	mv	s1,a0

  begin_op();
    80003916:	dc6ff0ef          	jal	80002edc <begin_op>

  if((ip = namei(path)) == 0){
    8000391a:	854a                	mv	a0,s2
    8000391c:	c04ff0ef          	jal	80002d20 <namei>
    80003920:	c931                	beqz	a0,80003974 <exec+0x80>
    80003922:	f3d2                	sd	s4,480(sp)
    80003924:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003926:	d21fe0ef          	jal	80002646 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000392a:	04000713          	li	a4,64
    8000392e:	4681                	li	a3,0
    80003930:	e5040613          	addi	a2,s0,-432
    80003934:	4581                	li	a1,0
    80003936:	8552                	mv	a0,s4
    80003938:	f63fe0ef          	jal	8000289a <readi>
    8000393c:	04000793          	li	a5,64
    80003940:	00f51a63          	bne	a0,a5,80003954 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003944:	e5042703          	lw	a4,-432(s0)
    80003948:	464c47b7          	lui	a5,0x464c4
    8000394c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003950:	02f70663          	beq	a4,a5,8000397c <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003954:	8552                	mv	a0,s4
    80003956:	efbfe0ef          	jal	80002850 <iunlockput>
    end_op();
    8000395a:	decff0ef          	jal	80002f46 <end_op>
  }
  return -1;
    8000395e:	557d                	li	a0,-1
    80003960:	7a1e                	ld	s4,480(sp)
}
    80003962:	20813083          	ld	ra,520(sp)
    80003966:	20013403          	ld	s0,512(sp)
    8000396a:	74fe                	ld	s1,504(sp)
    8000396c:	795e                	ld	s2,496(sp)
    8000396e:	21010113          	addi	sp,sp,528
    80003972:	8082                	ret
    end_op();
    80003974:	dd2ff0ef          	jal	80002f46 <end_op>
    return -1;
    80003978:	557d                	li	a0,-1
    8000397a:	b7e5                	j	80003962 <exec+0x6e>
    8000397c:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000397e:	8526                	mv	a0,s1
    80003980:	c8efd0ef          	jal	80000e0e <proc_pagetable>
    80003984:	8b2a                	mv	s6,a0
    80003986:	2c050b63          	beqz	a0,80003c5c <exec+0x368>
    8000398a:	f7ce                	sd	s3,488(sp)
    8000398c:	efd6                	sd	s5,472(sp)
    8000398e:	e7de                	sd	s7,456(sp)
    80003990:	e3e2                	sd	s8,448(sp)
    80003992:	ff66                	sd	s9,440(sp)
    80003994:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003996:	e7042d03          	lw	s10,-400(s0)
    8000399a:	e8845783          	lhu	a5,-376(s0)
    8000399e:	12078963          	beqz	a5,80003ad0 <exec+0x1dc>
    800039a2:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800039a4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800039a6:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800039a8:	6c85                	lui	s9,0x1
    800039aa:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800039ae:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800039b2:	6a85                	lui	s5,0x1
    800039b4:	a085                	j	80003a14 <exec+0x120>
      panic("loadseg: address should exist");
    800039b6:	00004517          	auipc	a0,0x4
    800039ba:	bea50513          	addi	a0,a0,-1046 # 800075a0 <etext+0x5a0>
    800039be:	235010ef          	jal	800053f2 <panic>
    if(sz - i < PGSIZE)
    800039c2:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800039c4:	8726                	mv	a4,s1
    800039c6:	012c06bb          	addw	a3,s8,s2
    800039ca:	4581                	li	a1,0
    800039cc:	8552                	mv	a0,s4
    800039ce:	ecdfe0ef          	jal	8000289a <readi>
    800039d2:	2501                	sext.w	a0,a0
    800039d4:	24a49a63          	bne	s1,a0,80003c28 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800039d8:	012a893b          	addw	s2,s5,s2
    800039dc:	03397363          	bgeu	s2,s3,80003a02 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800039e0:	02091593          	slli	a1,s2,0x20
    800039e4:	9181                	srli	a1,a1,0x20
    800039e6:	95de                	add	a1,a1,s7
    800039e8:	855a                	mv	a0,s6
    800039ea:	a73fc0ef          	jal	8000045c <walkaddr>
    800039ee:	862a                	mv	a2,a0
    if(pa == 0)
    800039f0:	d179                	beqz	a0,800039b6 <exec+0xc2>
    if(sz - i < PGSIZE)
    800039f2:	412984bb          	subw	s1,s3,s2
    800039f6:	0004879b          	sext.w	a5,s1
    800039fa:	fcfcf4e3          	bgeu	s9,a5,800039c2 <exec+0xce>
    800039fe:	84d6                	mv	s1,s5
    80003a00:	b7c9                	j	800039c2 <exec+0xce>
    sz = sz1;
    80003a02:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a06:	2d85                	addiw	s11,s11,1
    80003a08:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003a0c:	e8845783          	lhu	a5,-376(s0)
    80003a10:	08fdd063          	bge	s11,a5,80003a90 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003a14:	2d01                	sext.w	s10,s10
    80003a16:	03800713          	li	a4,56
    80003a1a:	86ea                	mv	a3,s10
    80003a1c:	e1840613          	addi	a2,s0,-488
    80003a20:	4581                	li	a1,0
    80003a22:	8552                	mv	a0,s4
    80003a24:	e77fe0ef          	jal	8000289a <readi>
    80003a28:	03800793          	li	a5,56
    80003a2c:	1cf51663          	bne	a0,a5,80003bf8 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003a30:	e1842783          	lw	a5,-488(s0)
    80003a34:	4705                	li	a4,1
    80003a36:	fce798e3          	bne	a5,a4,80003a06 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003a3a:	e4043483          	ld	s1,-448(s0)
    80003a3e:	e3843783          	ld	a5,-456(s0)
    80003a42:	1af4ef63          	bltu	s1,a5,80003c00 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003a46:	e2843783          	ld	a5,-472(s0)
    80003a4a:	94be                	add	s1,s1,a5
    80003a4c:	1af4ee63          	bltu	s1,a5,80003c08 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003a50:	df043703          	ld	a4,-528(s0)
    80003a54:	8ff9                	and	a5,a5,a4
    80003a56:	1a079d63          	bnez	a5,80003c10 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003a5a:	e1c42503          	lw	a0,-484(s0)
    80003a5e:	e7dff0ef          	jal	800038da <flags2perm>
    80003a62:	86aa                	mv	a3,a0
    80003a64:	8626                	mv	a2,s1
    80003a66:	85ca                	mv	a1,s2
    80003a68:	855a                	mv	a0,s6
    80003a6a:	d5bfc0ef          	jal	800007c4 <uvmalloc>
    80003a6e:	e0a43423          	sd	a0,-504(s0)
    80003a72:	1a050363          	beqz	a0,80003c18 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003a76:	e2843b83          	ld	s7,-472(s0)
    80003a7a:	e2042c03          	lw	s8,-480(s0)
    80003a7e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003a82:	00098463          	beqz	s3,80003a8a <exec+0x196>
    80003a86:	4901                	li	s2,0
    80003a88:	bfa1                	j	800039e0 <exec+0xec>
    sz = sz1;
    80003a8a:	e0843903          	ld	s2,-504(s0)
    80003a8e:	bfa5                	j	80003a06 <exec+0x112>
    80003a90:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003a92:	8552                	mv	a0,s4
    80003a94:	dbdfe0ef          	jal	80002850 <iunlockput>
  end_op();
    80003a98:	caeff0ef          	jal	80002f46 <end_op>
  p = myproc();
    80003a9c:	acafd0ef          	jal	80000d66 <myproc>
    80003aa0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003aa2:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003aa6:	6985                	lui	s3,0x1
    80003aa8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003aaa:	99ca                	add	s3,s3,s2
    80003aac:	77fd                	lui	a5,0xfffff
    80003aae:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003ab2:	4691                	li	a3,4
    80003ab4:	6609                	lui	a2,0x2
    80003ab6:	964e                	add	a2,a2,s3
    80003ab8:	85ce                	mv	a1,s3
    80003aba:	855a                	mv	a0,s6
    80003abc:	d09fc0ef          	jal	800007c4 <uvmalloc>
    80003ac0:	892a                	mv	s2,a0
    80003ac2:	e0a43423          	sd	a0,-504(s0)
    80003ac6:	e519                	bnez	a0,80003ad4 <exec+0x1e0>
  if(pagetable)
    80003ac8:	e1343423          	sd	s3,-504(s0)
    80003acc:	4a01                	li	s4,0
    80003ace:	aab1                	j	80003c2a <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ad0:	4901                	li	s2,0
    80003ad2:	b7c1                	j	80003a92 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003ad4:	75f9                	lui	a1,0xffffe
    80003ad6:	95aa                	add	a1,a1,a0
    80003ad8:	855a                	mv	a0,s6
    80003ada:	ed5fc0ef          	jal	800009ae <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003ade:	7bfd                	lui	s7,0xfffff
    80003ae0:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003ae2:	e0043783          	ld	a5,-512(s0)
    80003ae6:	6388                	ld	a0,0(a5)
    80003ae8:	cd39                	beqz	a0,80003b46 <exec+0x252>
    80003aea:	e9040993          	addi	s3,s0,-368
    80003aee:	f9040c13          	addi	s8,s0,-112
    80003af2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003af4:	fcafc0ef          	jal	800002be <strlen>
    80003af8:	0015079b          	addiw	a5,a0,1
    80003afc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003b00:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003b04:	11796e63          	bltu	s2,s7,80003c20 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003b08:	e0043d03          	ld	s10,-512(s0)
    80003b0c:	000d3a03          	ld	s4,0(s10)
    80003b10:	8552                	mv	a0,s4
    80003b12:	facfc0ef          	jal	800002be <strlen>
    80003b16:	0015069b          	addiw	a3,a0,1
    80003b1a:	8652                	mv	a2,s4
    80003b1c:	85ca                	mv	a1,s2
    80003b1e:	855a                	mv	a0,s6
    80003b20:	eb9fc0ef          	jal	800009d8 <copyout>
    80003b24:	10054063          	bltz	a0,80003c24 <exec+0x330>
    ustack[argc] = sp;
    80003b28:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003b2c:	0485                	addi	s1,s1,1
    80003b2e:	008d0793          	addi	a5,s10,8
    80003b32:	e0f43023          	sd	a5,-512(s0)
    80003b36:	008d3503          	ld	a0,8(s10)
    80003b3a:	c909                	beqz	a0,80003b4c <exec+0x258>
    if(argc >= MAXARG)
    80003b3c:	09a1                	addi	s3,s3,8
    80003b3e:	fb899be3          	bne	s3,s8,80003af4 <exec+0x200>
  ip = 0;
    80003b42:	4a01                	li	s4,0
    80003b44:	a0dd                	j	80003c2a <exec+0x336>
  sp = sz;
    80003b46:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003b4a:	4481                	li	s1,0
  ustack[argc] = 0;
    80003b4c:	00349793          	slli	a5,s1,0x3
    80003b50:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffde360>
    80003b54:	97a2                	add	a5,a5,s0
    80003b56:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003b5a:	00148693          	addi	a3,s1,1
    80003b5e:	068e                	slli	a3,a3,0x3
    80003b60:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003b64:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003b68:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003b6c:	f5796ee3          	bltu	s2,s7,80003ac8 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003b70:	e9040613          	addi	a2,s0,-368
    80003b74:	85ca                	mv	a1,s2
    80003b76:	855a                	mv	a0,s6
    80003b78:	e61fc0ef          	jal	800009d8 <copyout>
    80003b7c:	0e054263          	bltz	a0,80003c60 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003b80:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003b84:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003b88:	df843783          	ld	a5,-520(s0)
    80003b8c:	0007c703          	lbu	a4,0(a5)
    80003b90:	cf11                	beqz	a4,80003bac <exec+0x2b8>
    80003b92:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003b94:	02f00693          	li	a3,47
    80003b98:	a039                	j	80003ba6 <exec+0x2b2>
      last = s+1;
    80003b9a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003b9e:	0785                	addi	a5,a5,1
    80003ba0:	fff7c703          	lbu	a4,-1(a5)
    80003ba4:	c701                	beqz	a4,80003bac <exec+0x2b8>
    if(*s == '/')
    80003ba6:	fed71ce3          	bne	a4,a3,80003b9e <exec+0x2aa>
    80003baa:	bfc5                	j	80003b9a <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003bac:	4641                	li	a2,16
    80003bae:	df843583          	ld	a1,-520(s0)
    80003bb2:	158a8513          	addi	a0,s5,344
    80003bb6:	ed6fc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003bba:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003bbe:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003bc2:	e0843783          	ld	a5,-504(s0)
    80003bc6:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003bca:	058ab783          	ld	a5,88(s5)
    80003bce:	e6843703          	ld	a4,-408(s0)
    80003bd2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003bd4:	058ab783          	ld	a5,88(s5)
    80003bd8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003bdc:	85e6                	mv	a1,s9
    80003bde:	ab4fd0ef          	jal	80000e92 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003be2:	0004851b          	sext.w	a0,s1
    80003be6:	79be                	ld	s3,488(sp)
    80003be8:	7a1e                	ld	s4,480(sp)
    80003bea:	6afe                	ld	s5,472(sp)
    80003bec:	6b5e                	ld	s6,464(sp)
    80003bee:	6bbe                	ld	s7,456(sp)
    80003bf0:	6c1e                	ld	s8,448(sp)
    80003bf2:	7cfa                	ld	s9,440(sp)
    80003bf4:	7d5a                	ld	s10,432(sp)
    80003bf6:	b3b5                	j	80003962 <exec+0x6e>
    80003bf8:	e1243423          	sd	s2,-504(s0)
    80003bfc:	7dba                	ld	s11,424(sp)
    80003bfe:	a035                	j	80003c2a <exec+0x336>
    80003c00:	e1243423          	sd	s2,-504(s0)
    80003c04:	7dba                	ld	s11,424(sp)
    80003c06:	a015                	j	80003c2a <exec+0x336>
    80003c08:	e1243423          	sd	s2,-504(s0)
    80003c0c:	7dba                	ld	s11,424(sp)
    80003c0e:	a831                	j	80003c2a <exec+0x336>
    80003c10:	e1243423          	sd	s2,-504(s0)
    80003c14:	7dba                	ld	s11,424(sp)
    80003c16:	a811                	j	80003c2a <exec+0x336>
    80003c18:	e1243423          	sd	s2,-504(s0)
    80003c1c:	7dba                	ld	s11,424(sp)
    80003c1e:	a031                	j	80003c2a <exec+0x336>
  ip = 0;
    80003c20:	4a01                	li	s4,0
    80003c22:	a021                	j	80003c2a <exec+0x336>
    80003c24:	4a01                	li	s4,0
  if(pagetable)
    80003c26:	a011                	j	80003c2a <exec+0x336>
    80003c28:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003c2a:	e0843583          	ld	a1,-504(s0)
    80003c2e:	855a                	mv	a0,s6
    80003c30:	a62fd0ef          	jal	80000e92 <proc_freepagetable>
  return -1;
    80003c34:	557d                	li	a0,-1
  if(ip){
    80003c36:	000a1b63          	bnez	s4,80003c4c <exec+0x358>
    80003c3a:	79be                	ld	s3,488(sp)
    80003c3c:	7a1e                	ld	s4,480(sp)
    80003c3e:	6afe                	ld	s5,472(sp)
    80003c40:	6b5e                	ld	s6,464(sp)
    80003c42:	6bbe                	ld	s7,456(sp)
    80003c44:	6c1e                	ld	s8,448(sp)
    80003c46:	7cfa                	ld	s9,440(sp)
    80003c48:	7d5a                	ld	s10,432(sp)
    80003c4a:	bb21                	j	80003962 <exec+0x6e>
    80003c4c:	79be                	ld	s3,488(sp)
    80003c4e:	6afe                	ld	s5,472(sp)
    80003c50:	6b5e                	ld	s6,464(sp)
    80003c52:	6bbe                	ld	s7,456(sp)
    80003c54:	6c1e                	ld	s8,448(sp)
    80003c56:	7cfa                	ld	s9,440(sp)
    80003c58:	7d5a                	ld	s10,432(sp)
    80003c5a:	b9ed                	j	80003954 <exec+0x60>
    80003c5c:	6b5e                	ld	s6,464(sp)
    80003c5e:	b9dd                	j	80003954 <exec+0x60>
  sz = sz1;
    80003c60:	e0843983          	ld	s3,-504(s0)
    80003c64:	b595                	j	80003ac8 <exec+0x1d4>

0000000080003c66 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003c66:	7179                	addi	sp,sp,-48
    80003c68:	f406                	sd	ra,40(sp)
    80003c6a:	f022                	sd	s0,32(sp)
    80003c6c:	ec26                	sd	s1,24(sp)
    80003c6e:	e84a                	sd	s2,16(sp)
    80003c70:	1800                	addi	s0,sp,48
    80003c72:	892e                	mv	s2,a1
    80003c74:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003c76:	fdc40593          	addi	a1,s0,-36
    80003c7a:	fa1fd0ef          	jal	80001c1a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003c7e:	fdc42703          	lw	a4,-36(s0)
    80003c82:	47bd                	li	a5,15
    80003c84:	02e7e963          	bltu	a5,a4,80003cb6 <argfd+0x50>
    80003c88:	8defd0ef          	jal	80000d66 <myproc>
    80003c8c:	fdc42703          	lw	a4,-36(s0)
    80003c90:	01a70793          	addi	a5,a4,26
    80003c94:	078e                	slli	a5,a5,0x3
    80003c96:	953e                	add	a0,a0,a5
    80003c98:	611c                	ld	a5,0(a0)
    80003c9a:	c385                	beqz	a5,80003cba <argfd+0x54>
    return -1;
  if(pfd)
    80003c9c:	00090463          	beqz	s2,80003ca4 <argfd+0x3e>
    *pfd = fd;
    80003ca0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003ca4:	4501                	li	a0,0
  if(pf)
    80003ca6:	c091                	beqz	s1,80003caa <argfd+0x44>
    *pf = f;
    80003ca8:	e09c                	sd	a5,0(s1)
}
    80003caa:	70a2                	ld	ra,40(sp)
    80003cac:	7402                	ld	s0,32(sp)
    80003cae:	64e2                	ld	s1,24(sp)
    80003cb0:	6942                	ld	s2,16(sp)
    80003cb2:	6145                	addi	sp,sp,48
    80003cb4:	8082                	ret
    return -1;
    80003cb6:	557d                	li	a0,-1
    80003cb8:	bfcd                	j	80003caa <argfd+0x44>
    80003cba:	557d                	li	a0,-1
    80003cbc:	b7fd                	j	80003caa <argfd+0x44>

0000000080003cbe <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003cbe:	1101                	addi	sp,sp,-32
    80003cc0:	ec06                	sd	ra,24(sp)
    80003cc2:	e822                	sd	s0,16(sp)
    80003cc4:	e426                	sd	s1,8(sp)
    80003cc6:	1000                	addi	s0,sp,32
    80003cc8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003cca:	89cfd0ef          	jal	80000d66 <myproc>
    80003cce:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003cd0:	0d050793          	addi	a5,a0,208
    80003cd4:	4501                	li	a0,0
    80003cd6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003cd8:	6398                	ld	a4,0(a5)
    80003cda:	cb19                	beqz	a4,80003cf0 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003cdc:	2505                	addiw	a0,a0,1
    80003cde:	07a1                	addi	a5,a5,8
    80003ce0:	fed51ce3          	bne	a0,a3,80003cd8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003ce4:	557d                	li	a0,-1
}
    80003ce6:	60e2                	ld	ra,24(sp)
    80003ce8:	6442                	ld	s0,16(sp)
    80003cea:	64a2                	ld	s1,8(sp)
    80003cec:	6105                	addi	sp,sp,32
    80003cee:	8082                	ret
      p->ofile[fd] = f;
    80003cf0:	01a50793          	addi	a5,a0,26
    80003cf4:	078e                	slli	a5,a5,0x3
    80003cf6:	963e                	add	a2,a2,a5
    80003cf8:	e204                	sd	s1,0(a2)
      return fd;
    80003cfa:	b7f5                	j	80003ce6 <fdalloc+0x28>

0000000080003cfc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003cfc:	715d                	addi	sp,sp,-80
    80003cfe:	e486                	sd	ra,72(sp)
    80003d00:	e0a2                	sd	s0,64(sp)
    80003d02:	fc26                	sd	s1,56(sp)
    80003d04:	f84a                	sd	s2,48(sp)
    80003d06:	f44e                	sd	s3,40(sp)
    80003d08:	ec56                	sd	s5,24(sp)
    80003d0a:	e85a                	sd	s6,16(sp)
    80003d0c:	0880                	addi	s0,sp,80
    80003d0e:	8b2e                	mv	s6,a1
    80003d10:	89b2                	mv	s3,a2
    80003d12:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003d14:	fb040593          	addi	a1,s0,-80
    80003d18:	822ff0ef          	jal	80002d3a <nameiparent>
    80003d1c:	84aa                	mv	s1,a0
    80003d1e:	10050a63          	beqz	a0,80003e32 <create+0x136>
    return 0;

  ilock(dp);
    80003d22:	925fe0ef          	jal	80002646 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d26:	4601                	li	a2,0
    80003d28:	fb040593          	addi	a1,s0,-80
    80003d2c:	8526                	mv	a0,s1
    80003d2e:	d8dfe0ef          	jal	80002aba <dirlookup>
    80003d32:	8aaa                	mv	s5,a0
    80003d34:	c129                	beqz	a0,80003d76 <create+0x7a>
    iunlockput(dp);
    80003d36:	8526                	mv	a0,s1
    80003d38:	b19fe0ef          	jal	80002850 <iunlockput>
    ilock(ip);
    80003d3c:	8556                	mv	a0,s5
    80003d3e:	909fe0ef          	jal	80002646 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003d42:	4789                	li	a5,2
    80003d44:	02fb1463          	bne	s6,a5,80003d6c <create+0x70>
    80003d48:	044ad783          	lhu	a5,68(s5)
    80003d4c:	37f9                	addiw	a5,a5,-2
    80003d4e:	17c2                	slli	a5,a5,0x30
    80003d50:	93c1                	srli	a5,a5,0x30
    80003d52:	4705                	li	a4,1
    80003d54:	00f76c63          	bltu	a4,a5,80003d6c <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003d58:	8556                	mv	a0,s5
    80003d5a:	60a6                	ld	ra,72(sp)
    80003d5c:	6406                	ld	s0,64(sp)
    80003d5e:	74e2                	ld	s1,56(sp)
    80003d60:	7942                	ld	s2,48(sp)
    80003d62:	79a2                	ld	s3,40(sp)
    80003d64:	6ae2                	ld	s5,24(sp)
    80003d66:	6b42                	ld	s6,16(sp)
    80003d68:	6161                	addi	sp,sp,80
    80003d6a:	8082                	ret
    iunlockput(ip);
    80003d6c:	8556                	mv	a0,s5
    80003d6e:	ae3fe0ef          	jal	80002850 <iunlockput>
    return 0;
    80003d72:	4a81                	li	s5,0
    80003d74:	b7d5                	j	80003d58 <create+0x5c>
    80003d76:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003d78:	85da                	mv	a1,s6
    80003d7a:	4088                	lw	a0,0(s1)
    80003d7c:	f5afe0ef          	jal	800024d6 <ialloc>
    80003d80:	8a2a                	mv	s4,a0
    80003d82:	cd15                	beqz	a0,80003dbe <create+0xc2>
  ilock(ip);
    80003d84:	8c3fe0ef          	jal	80002646 <ilock>
  ip->major = major;
    80003d88:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003d8c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003d90:	4905                	li	s2,1
    80003d92:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003d96:	8552                	mv	a0,s4
    80003d98:	ffafe0ef          	jal	80002592 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003d9c:	032b0763          	beq	s6,s2,80003dca <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003da0:	004a2603          	lw	a2,4(s4)
    80003da4:	fb040593          	addi	a1,s0,-80
    80003da8:	8526                	mv	a0,s1
    80003daa:	eddfe0ef          	jal	80002c86 <dirlink>
    80003dae:	06054563          	bltz	a0,80003e18 <create+0x11c>
  iunlockput(dp);
    80003db2:	8526                	mv	a0,s1
    80003db4:	a9dfe0ef          	jal	80002850 <iunlockput>
  return ip;
    80003db8:	8ad2                	mv	s5,s4
    80003dba:	7a02                	ld	s4,32(sp)
    80003dbc:	bf71                	j	80003d58 <create+0x5c>
    iunlockput(dp);
    80003dbe:	8526                	mv	a0,s1
    80003dc0:	a91fe0ef          	jal	80002850 <iunlockput>
    return 0;
    80003dc4:	8ad2                	mv	s5,s4
    80003dc6:	7a02                	ld	s4,32(sp)
    80003dc8:	bf41                	j	80003d58 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003dca:	004a2603          	lw	a2,4(s4)
    80003dce:	00003597          	auipc	a1,0x3
    80003dd2:	7f258593          	addi	a1,a1,2034 # 800075c0 <etext+0x5c0>
    80003dd6:	8552                	mv	a0,s4
    80003dd8:	eaffe0ef          	jal	80002c86 <dirlink>
    80003ddc:	02054e63          	bltz	a0,80003e18 <create+0x11c>
    80003de0:	40d0                	lw	a2,4(s1)
    80003de2:	00003597          	auipc	a1,0x3
    80003de6:	7e658593          	addi	a1,a1,2022 # 800075c8 <etext+0x5c8>
    80003dea:	8552                	mv	a0,s4
    80003dec:	e9bfe0ef          	jal	80002c86 <dirlink>
    80003df0:	02054463          	bltz	a0,80003e18 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003df4:	004a2603          	lw	a2,4(s4)
    80003df8:	fb040593          	addi	a1,s0,-80
    80003dfc:	8526                	mv	a0,s1
    80003dfe:	e89fe0ef          	jal	80002c86 <dirlink>
    80003e02:	00054b63          	bltz	a0,80003e18 <create+0x11c>
    dp->nlink++;  // for ".."
    80003e06:	04a4d783          	lhu	a5,74(s1)
    80003e0a:	2785                	addiw	a5,a5,1
    80003e0c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003e10:	8526                	mv	a0,s1
    80003e12:	f80fe0ef          	jal	80002592 <iupdate>
    80003e16:	bf71                	j	80003db2 <create+0xb6>
  ip->nlink = 0;
    80003e18:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003e1c:	8552                	mv	a0,s4
    80003e1e:	f74fe0ef          	jal	80002592 <iupdate>
  iunlockput(ip);
    80003e22:	8552                	mv	a0,s4
    80003e24:	a2dfe0ef          	jal	80002850 <iunlockput>
  iunlockput(dp);
    80003e28:	8526                	mv	a0,s1
    80003e2a:	a27fe0ef          	jal	80002850 <iunlockput>
  return 0;
    80003e2e:	7a02                	ld	s4,32(sp)
    80003e30:	b725                	j	80003d58 <create+0x5c>
    return 0;
    80003e32:	8aaa                	mv	s5,a0
    80003e34:	b715                	j	80003d58 <create+0x5c>

0000000080003e36 <sys_dup>:
{
    80003e36:	7179                	addi	sp,sp,-48
    80003e38:	f406                	sd	ra,40(sp)
    80003e3a:	f022                	sd	s0,32(sp)
    80003e3c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003e3e:	fd840613          	addi	a2,s0,-40
    80003e42:	4581                	li	a1,0
    80003e44:	4501                	li	a0,0
    80003e46:	e21ff0ef          	jal	80003c66 <argfd>
    return -1;
    80003e4a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003e4c:	02054363          	bltz	a0,80003e72 <sys_dup+0x3c>
    80003e50:	ec26                	sd	s1,24(sp)
    80003e52:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003e54:	fd843903          	ld	s2,-40(s0)
    80003e58:	854a                	mv	a0,s2
    80003e5a:	e65ff0ef          	jal	80003cbe <fdalloc>
    80003e5e:	84aa                	mv	s1,a0
    return -1;
    80003e60:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003e62:	00054d63          	bltz	a0,80003e7c <sys_dup+0x46>
  filedup(f);
    80003e66:	854a                	mv	a0,s2
    80003e68:	c48ff0ef          	jal	800032b0 <filedup>
  return fd;
    80003e6c:	87a6                	mv	a5,s1
    80003e6e:	64e2                	ld	s1,24(sp)
    80003e70:	6942                	ld	s2,16(sp)
}
    80003e72:	853e                	mv	a0,a5
    80003e74:	70a2                	ld	ra,40(sp)
    80003e76:	7402                	ld	s0,32(sp)
    80003e78:	6145                	addi	sp,sp,48
    80003e7a:	8082                	ret
    80003e7c:	64e2                	ld	s1,24(sp)
    80003e7e:	6942                	ld	s2,16(sp)
    80003e80:	bfcd                	j	80003e72 <sys_dup+0x3c>

0000000080003e82 <sys_read>:
{
    80003e82:	7179                	addi	sp,sp,-48
    80003e84:	f406                	sd	ra,40(sp)
    80003e86:	f022                	sd	s0,32(sp)
    80003e88:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003e8a:	fd840593          	addi	a1,s0,-40
    80003e8e:	4505                	li	a0,1
    80003e90:	da7fd0ef          	jal	80001c36 <argaddr>
  argint(2, &n);
    80003e94:	fe440593          	addi	a1,s0,-28
    80003e98:	4509                	li	a0,2
    80003e9a:	d81fd0ef          	jal	80001c1a <argint>
  if(argfd(0, 0, &f) < 0)
    80003e9e:	fe840613          	addi	a2,s0,-24
    80003ea2:	4581                	li	a1,0
    80003ea4:	4501                	li	a0,0
    80003ea6:	dc1ff0ef          	jal	80003c66 <argfd>
    80003eaa:	87aa                	mv	a5,a0
    return -1;
    80003eac:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003eae:	0007ca63          	bltz	a5,80003ec2 <sys_read+0x40>
  return fileread(f, p, n);
    80003eb2:	fe442603          	lw	a2,-28(s0)
    80003eb6:	fd843583          	ld	a1,-40(s0)
    80003eba:	fe843503          	ld	a0,-24(s0)
    80003ebe:	d58ff0ef          	jal	80003416 <fileread>
}
    80003ec2:	70a2                	ld	ra,40(sp)
    80003ec4:	7402                	ld	s0,32(sp)
    80003ec6:	6145                	addi	sp,sp,48
    80003ec8:	8082                	ret

0000000080003eca <sys_write>:
{
    80003eca:	7179                	addi	sp,sp,-48
    80003ecc:	f406                	sd	ra,40(sp)
    80003ece:	f022                	sd	s0,32(sp)
    80003ed0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ed2:	fd840593          	addi	a1,s0,-40
    80003ed6:	4505                	li	a0,1
    80003ed8:	d5ffd0ef          	jal	80001c36 <argaddr>
  argint(2, &n);
    80003edc:	fe440593          	addi	a1,s0,-28
    80003ee0:	4509                	li	a0,2
    80003ee2:	d39fd0ef          	jal	80001c1a <argint>
  if(argfd(0, 0, &f) < 0)
    80003ee6:	fe840613          	addi	a2,s0,-24
    80003eea:	4581                	li	a1,0
    80003eec:	4501                	li	a0,0
    80003eee:	d79ff0ef          	jal	80003c66 <argfd>
    80003ef2:	87aa                	mv	a5,a0
    return -1;
    80003ef4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003ef6:	0007ca63          	bltz	a5,80003f0a <sys_write+0x40>
  return filewrite(f, p, n);
    80003efa:	fe442603          	lw	a2,-28(s0)
    80003efe:	fd843583          	ld	a1,-40(s0)
    80003f02:	fe843503          	ld	a0,-24(s0)
    80003f06:	dceff0ef          	jal	800034d4 <filewrite>
}
    80003f0a:	70a2                	ld	ra,40(sp)
    80003f0c:	7402                	ld	s0,32(sp)
    80003f0e:	6145                	addi	sp,sp,48
    80003f10:	8082                	ret

0000000080003f12 <sys_close>:
{
    80003f12:	1101                	addi	sp,sp,-32
    80003f14:	ec06                	sd	ra,24(sp)
    80003f16:	e822                	sd	s0,16(sp)
    80003f18:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003f1a:	fe040613          	addi	a2,s0,-32
    80003f1e:	fec40593          	addi	a1,s0,-20
    80003f22:	4501                	li	a0,0
    80003f24:	d43ff0ef          	jal	80003c66 <argfd>
    return -1;
    80003f28:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003f2a:	02054063          	bltz	a0,80003f4a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003f2e:	e39fc0ef          	jal	80000d66 <myproc>
    80003f32:	fec42783          	lw	a5,-20(s0)
    80003f36:	07e9                	addi	a5,a5,26
    80003f38:	078e                	slli	a5,a5,0x3
    80003f3a:	953e                	add	a0,a0,a5
    80003f3c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003f40:	fe043503          	ld	a0,-32(s0)
    80003f44:	bb2ff0ef          	jal	800032f6 <fileclose>
  return 0;
    80003f48:	4781                	li	a5,0
}
    80003f4a:	853e                	mv	a0,a5
    80003f4c:	60e2                	ld	ra,24(sp)
    80003f4e:	6442                	ld	s0,16(sp)
    80003f50:	6105                	addi	sp,sp,32
    80003f52:	8082                	ret

0000000080003f54 <sys_fstat>:
{
    80003f54:	1101                	addi	sp,sp,-32
    80003f56:	ec06                	sd	ra,24(sp)
    80003f58:	e822                	sd	s0,16(sp)
    80003f5a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003f5c:	fe040593          	addi	a1,s0,-32
    80003f60:	4505                	li	a0,1
    80003f62:	cd5fd0ef          	jal	80001c36 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003f66:	fe840613          	addi	a2,s0,-24
    80003f6a:	4581                	li	a1,0
    80003f6c:	4501                	li	a0,0
    80003f6e:	cf9ff0ef          	jal	80003c66 <argfd>
    80003f72:	87aa                	mv	a5,a0
    return -1;
    80003f74:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f76:	0007c863          	bltz	a5,80003f86 <sys_fstat+0x32>
  return filestat(f, st);
    80003f7a:	fe043583          	ld	a1,-32(s0)
    80003f7e:	fe843503          	ld	a0,-24(s0)
    80003f82:	c36ff0ef          	jal	800033b8 <filestat>
}
    80003f86:	60e2                	ld	ra,24(sp)
    80003f88:	6442                	ld	s0,16(sp)
    80003f8a:	6105                	addi	sp,sp,32
    80003f8c:	8082                	ret

0000000080003f8e <sys_link>:
{
    80003f8e:	7169                	addi	sp,sp,-304
    80003f90:	f606                	sd	ra,296(sp)
    80003f92:	f222                	sd	s0,288(sp)
    80003f94:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f96:	08000613          	li	a2,128
    80003f9a:	ed040593          	addi	a1,s0,-304
    80003f9e:	4501                	li	a0,0
    80003fa0:	cb3fd0ef          	jal	80001c52 <argstr>
    return -1;
    80003fa4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003fa6:	0c054e63          	bltz	a0,80004082 <sys_link+0xf4>
    80003faa:	08000613          	li	a2,128
    80003fae:	f5040593          	addi	a1,s0,-176
    80003fb2:	4505                	li	a0,1
    80003fb4:	c9ffd0ef          	jal	80001c52 <argstr>
    return -1;
    80003fb8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003fba:	0c054463          	bltz	a0,80004082 <sys_link+0xf4>
    80003fbe:	ee26                	sd	s1,280(sp)
  begin_op();
    80003fc0:	f1dfe0ef          	jal	80002edc <begin_op>
  if((ip = namei(old)) == 0){
    80003fc4:	ed040513          	addi	a0,s0,-304
    80003fc8:	d59fe0ef          	jal	80002d20 <namei>
    80003fcc:	84aa                	mv	s1,a0
    80003fce:	c53d                	beqz	a0,8000403c <sys_link+0xae>
  ilock(ip);
    80003fd0:	e76fe0ef          	jal	80002646 <ilock>
  if(ip->type == T_DIR){
    80003fd4:	04449703          	lh	a4,68(s1)
    80003fd8:	4785                	li	a5,1
    80003fda:	06f70663          	beq	a4,a5,80004046 <sys_link+0xb8>
    80003fde:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80003fe0:	04a4d783          	lhu	a5,74(s1)
    80003fe4:	2785                	addiw	a5,a5,1
    80003fe6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80003fea:	8526                	mv	a0,s1
    80003fec:	da6fe0ef          	jal	80002592 <iupdate>
  iunlock(ip);
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	f02fe0ef          	jal	800026f4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80003ff6:	fd040593          	addi	a1,s0,-48
    80003ffa:	f5040513          	addi	a0,s0,-176
    80003ffe:	d3dfe0ef          	jal	80002d3a <nameiparent>
    80004002:	892a                	mv	s2,a0
    80004004:	cd21                	beqz	a0,8000405c <sys_link+0xce>
  ilock(dp);
    80004006:	e40fe0ef          	jal	80002646 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000400a:	00092703          	lw	a4,0(s2)
    8000400e:	409c                	lw	a5,0(s1)
    80004010:	04f71363          	bne	a4,a5,80004056 <sys_link+0xc8>
    80004014:	40d0                	lw	a2,4(s1)
    80004016:	fd040593          	addi	a1,s0,-48
    8000401a:	854a                	mv	a0,s2
    8000401c:	c6bfe0ef          	jal	80002c86 <dirlink>
    80004020:	02054b63          	bltz	a0,80004056 <sys_link+0xc8>
  iunlockput(dp);
    80004024:	854a                	mv	a0,s2
    80004026:	82bfe0ef          	jal	80002850 <iunlockput>
  iput(ip);
    8000402a:	8526                	mv	a0,s1
    8000402c:	f9cfe0ef          	jal	800027c8 <iput>
  end_op();
    80004030:	f17fe0ef          	jal	80002f46 <end_op>
  return 0;
    80004034:	4781                	li	a5,0
    80004036:	64f2                	ld	s1,280(sp)
    80004038:	6952                	ld	s2,272(sp)
    8000403a:	a0a1                	j	80004082 <sys_link+0xf4>
    end_op();
    8000403c:	f0bfe0ef          	jal	80002f46 <end_op>
    return -1;
    80004040:	57fd                	li	a5,-1
    80004042:	64f2                	ld	s1,280(sp)
    80004044:	a83d                	j	80004082 <sys_link+0xf4>
    iunlockput(ip);
    80004046:	8526                	mv	a0,s1
    80004048:	809fe0ef          	jal	80002850 <iunlockput>
    end_op();
    8000404c:	efbfe0ef          	jal	80002f46 <end_op>
    return -1;
    80004050:	57fd                	li	a5,-1
    80004052:	64f2                	ld	s1,280(sp)
    80004054:	a03d                	j	80004082 <sys_link+0xf4>
    iunlockput(dp);
    80004056:	854a                	mv	a0,s2
    80004058:	ff8fe0ef          	jal	80002850 <iunlockput>
  ilock(ip);
    8000405c:	8526                	mv	a0,s1
    8000405e:	de8fe0ef          	jal	80002646 <ilock>
  ip->nlink--;
    80004062:	04a4d783          	lhu	a5,74(s1)
    80004066:	37fd                	addiw	a5,a5,-1
    80004068:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000406c:	8526                	mv	a0,s1
    8000406e:	d24fe0ef          	jal	80002592 <iupdate>
  iunlockput(ip);
    80004072:	8526                	mv	a0,s1
    80004074:	fdcfe0ef          	jal	80002850 <iunlockput>
  end_op();
    80004078:	ecffe0ef          	jal	80002f46 <end_op>
  return -1;
    8000407c:	57fd                	li	a5,-1
    8000407e:	64f2                	ld	s1,280(sp)
    80004080:	6952                	ld	s2,272(sp)
}
    80004082:	853e                	mv	a0,a5
    80004084:	70b2                	ld	ra,296(sp)
    80004086:	7412                	ld	s0,288(sp)
    80004088:	6155                	addi	sp,sp,304
    8000408a:	8082                	ret

000000008000408c <sys_unlink>:
{
    8000408c:	7151                	addi	sp,sp,-240
    8000408e:	f586                	sd	ra,232(sp)
    80004090:	f1a2                	sd	s0,224(sp)
    80004092:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004094:	08000613          	li	a2,128
    80004098:	f3040593          	addi	a1,s0,-208
    8000409c:	4501                	li	a0,0
    8000409e:	bb5fd0ef          	jal	80001c52 <argstr>
    800040a2:	16054063          	bltz	a0,80004202 <sys_unlink+0x176>
    800040a6:	eda6                	sd	s1,216(sp)
  begin_op();
    800040a8:	e35fe0ef          	jal	80002edc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800040ac:	fb040593          	addi	a1,s0,-80
    800040b0:	f3040513          	addi	a0,s0,-208
    800040b4:	c87fe0ef          	jal	80002d3a <nameiparent>
    800040b8:	84aa                	mv	s1,a0
    800040ba:	c945                	beqz	a0,8000416a <sys_unlink+0xde>
  ilock(dp);
    800040bc:	d8afe0ef          	jal	80002646 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800040c0:	00003597          	auipc	a1,0x3
    800040c4:	50058593          	addi	a1,a1,1280 # 800075c0 <etext+0x5c0>
    800040c8:	fb040513          	addi	a0,s0,-80
    800040cc:	9d9fe0ef          	jal	80002aa4 <namecmp>
    800040d0:	10050e63          	beqz	a0,800041ec <sys_unlink+0x160>
    800040d4:	00003597          	auipc	a1,0x3
    800040d8:	4f458593          	addi	a1,a1,1268 # 800075c8 <etext+0x5c8>
    800040dc:	fb040513          	addi	a0,s0,-80
    800040e0:	9c5fe0ef          	jal	80002aa4 <namecmp>
    800040e4:	10050463          	beqz	a0,800041ec <sys_unlink+0x160>
    800040e8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800040ea:	f2c40613          	addi	a2,s0,-212
    800040ee:	fb040593          	addi	a1,s0,-80
    800040f2:	8526                	mv	a0,s1
    800040f4:	9c7fe0ef          	jal	80002aba <dirlookup>
    800040f8:	892a                	mv	s2,a0
    800040fa:	0e050863          	beqz	a0,800041ea <sys_unlink+0x15e>
  ilock(ip);
    800040fe:	d48fe0ef          	jal	80002646 <ilock>
  if(ip->nlink < 1)
    80004102:	04a91783          	lh	a5,74(s2)
    80004106:	06f05763          	blez	a5,80004174 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000410a:	04491703          	lh	a4,68(s2)
    8000410e:	4785                	li	a5,1
    80004110:	06f70963          	beq	a4,a5,80004182 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004114:	4641                	li	a2,16
    80004116:	4581                	li	a1,0
    80004118:	fc040513          	addi	a0,s0,-64
    8000411c:	832fc0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004120:	4741                	li	a4,16
    80004122:	f2c42683          	lw	a3,-212(s0)
    80004126:	fc040613          	addi	a2,s0,-64
    8000412a:	4581                	li	a1,0
    8000412c:	8526                	mv	a0,s1
    8000412e:	869fe0ef          	jal	80002996 <writei>
    80004132:	47c1                	li	a5,16
    80004134:	08f51b63          	bne	a0,a5,800041ca <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004138:	04491703          	lh	a4,68(s2)
    8000413c:	4785                	li	a5,1
    8000413e:	08f70d63          	beq	a4,a5,800041d8 <sys_unlink+0x14c>
  iunlockput(dp);
    80004142:	8526                	mv	a0,s1
    80004144:	f0cfe0ef          	jal	80002850 <iunlockput>
  ip->nlink--;
    80004148:	04a95783          	lhu	a5,74(s2)
    8000414c:	37fd                	addiw	a5,a5,-1
    8000414e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004152:	854a                	mv	a0,s2
    80004154:	c3efe0ef          	jal	80002592 <iupdate>
  iunlockput(ip);
    80004158:	854a                	mv	a0,s2
    8000415a:	ef6fe0ef          	jal	80002850 <iunlockput>
  end_op();
    8000415e:	de9fe0ef          	jal	80002f46 <end_op>
  return 0;
    80004162:	4501                	li	a0,0
    80004164:	64ee                	ld	s1,216(sp)
    80004166:	694e                	ld	s2,208(sp)
    80004168:	a849                	j	800041fa <sys_unlink+0x16e>
    end_op();
    8000416a:	dddfe0ef          	jal	80002f46 <end_op>
    return -1;
    8000416e:	557d                	li	a0,-1
    80004170:	64ee                	ld	s1,216(sp)
    80004172:	a061                	j	800041fa <sys_unlink+0x16e>
    80004174:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004176:	00003517          	auipc	a0,0x3
    8000417a:	45a50513          	addi	a0,a0,1114 # 800075d0 <etext+0x5d0>
    8000417e:	274010ef          	jal	800053f2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004182:	04c92703          	lw	a4,76(s2)
    80004186:	02000793          	li	a5,32
    8000418a:	f8e7f5e3          	bgeu	a5,a4,80004114 <sys_unlink+0x88>
    8000418e:	e5ce                	sd	s3,200(sp)
    80004190:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004194:	4741                	li	a4,16
    80004196:	86ce                	mv	a3,s3
    80004198:	f1840613          	addi	a2,s0,-232
    8000419c:	4581                	li	a1,0
    8000419e:	854a                	mv	a0,s2
    800041a0:	efafe0ef          	jal	8000289a <readi>
    800041a4:	47c1                	li	a5,16
    800041a6:	00f51c63          	bne	a0,a5,800041be <sys_unlink+0x132>
    if(de.inum != 0)
    800041aa:	f1845783          	lhu	a5,-232(s0)
    800041ae:	efa1                	bnez	a5,80004206 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800041b0:	29c1                	addiw	s3,s3,16
    800041b2:	04c92783          	lw	a5,76(s2)
    800041b6:	fcf9efe3          	bltu	s3,a5,80004194 <sys_unlink+0x108>
    800041ba:	69ae                	ld	s3,200(sp)
    800041bc:	bfa1                	j	80004114 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800041be:	00003517          	auipc	a0,0x3
    800041c2:	42a50513          	addi	a0,a0,1066 # 800075e8 <etext+0x5e8>
    800041c6:	22c010ef          	jal	800053f2 <panic>
    800041ca:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800041cc:	00003517          	auipc	a0,0x3
    800041d0:	43450513          	addi	a0,a0,1076 # 80007600 <etext+0x600>
    800041d4:	21e010ef          	jal	800053f2 <panic>
    dp->nlink--;
    800041d8:	04a4d783          	lhu	a5,74(s1)
    800041dc:	37fd                	addiw	a5,a5,-1
    800041de:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800041e2:	8526                	mv	a0,s1
    800041e4:	baefe0ef          	jal	80002592 <iupdate>
    800041e8:	bfa9                	j	80004142 <sys_unlink+0xb6>
    800041ea:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800041ec:	8526                	mv	a0,s1
    800041ee:	e62fe0ef          	jal	80002850 <iunlockput>
  end_op();
    800041f2:	d55fe0ef          	jal	80002f46 <end_op>
  return -1;
    800041f6:	557d                	li	a0,-1
    800041f8:	64ee                	ld	s1,216(sp)
}
    800041fa:	70ae                	ld	ra,232(sp)
    800041fc:	740e                	ld	s0,224(sp)
    800041fe:	616d                	addi	sp,sp,240
    80004200:	8082                	ret
    return -1;
    80004202:	557d                	li	a0,-1
    80004204:	bfdd                	j	800041fa <sys_unlink+0x16e>
    iunlockput(ip);
    80004206:	854a                	mv	a0,s2
    80004208:	e48fe0ef          	jal	80002850 <iunlockput>
    goto bad;
    8000420c:	694e                	ld	s2,208(sp)
    8000420e:	69ae                	ld	s3,200(sp)
    80004210:	bff1                	j	800041ec <sys_unlink+0x160>

0000000080004212 <sys_open>:

uint64
sys_open(void)
{
    80004212:	7131                	addi	sp,sp,-192
    80004214:	fd06                	sd	ra,184(sp)
    80004216:	f922                	sd	s0,176(sp)
    80004218:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000421a:	f4c40593          	addi	a1,s0,-180
    8000421e:	4505                	li	a0,1
    80004220:	9fbfd0ef          	jal	80001c1a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004224:	08000613          	li	a2,128
    80004228:	f5040593          	addi	a1,s0,-176
    8000422c:	4501                	li	a0,0
    8000422e:	a25fd0ef          	jal	80001c52 <argstr>
    80004232:	87aa                	mv	a5,a0
    return -1;
    80004234:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004236:	0a07c263          	bltz	a5,800042da <sys_open+0xc8>
    8000423a:	f526                	sd	s1,168(sp)

  begin_op();
    8000423c:	ca1fe0ef          	jal	80002edc <begin_op>

  if(omode & O_CREATE){
    80004240:	f4c42783          	lw	a5,-180(s0)
    80004244:	2007f793          	andi	a5,a5,512
    80004248:	c3d5                	beqz	a5,800042ec <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000424a:	4681                	li	a3,0
    8000424c:	4601                	li	a2,0
    8000424e:	4589                	li	a1,2
    80004250:	f5040513          	addi	a0,s0,-176
    80004254:	aa9ff0ef          	jal	80003cfc <create>
    80004258:	84aa                	mv	s1,a0
    if(ip == 0){
    8000425a:	c541                	beqz	a0,800042e2 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000425c:	04449703          	lh	a4,68(s1)
    80004260:	478d                	li	a5,3
    80004262:	00f71763          	bne	a4,a5,80004270 <sys_open+0x5e>
    80004266:	0464d703          	lhu	a4,70(s1)
    8000426a:	47a5                	li	a5,9
    8000426c:	0ae7ed63          	bltu	a5,a4,80004326 <sys_open+0x114>
    80004270:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004272:	fe1fe0ef          	jal	80003252 <filealloc>
    80004276:	892a                	mv	s2,a0
    80004278:	c179                	beqz	a0,8000433e <sys_open+0x12c>
    8000427a:	ed4e                	sd	s3,152(sp)
    8000427c:	a43ff0ef          	jal	80003cbe <fdalloc>
    80004280:	89aa                	mv	s3,a0
    80004282:	0a054a63          	bltz	a0,80004336 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004286:	04449703          	lh	a4,68(s1)
    8000428a:	478d                	li	a5,3
    8000428c:	0cf70263          	beq	a4,a5,80004350 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004290:	4789                	li	a5,2
    80004292:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004296:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000429a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000429e:	f4c42783          	lw	a5,-180(s0)
    800042a2:	0017c713          	xori	a4,a5,1
    800042a6:	8b05                	andi	a4,a4,1
    800042a8:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800042ac:	0037f713          	andi	a4,a5,3
    800042b0:	00e03733          	snez	a4,a4
    800042b4:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800042b8:	4007f793          	andi	a5,a5,1024
    800042bc:	c791                	beqz	a5,800042c8 <sys_open+0xb6>
    800042be:	04449703          	lh	a4,68(s1)
    800042c2:	4789                	li	a5,2
    800042c4:	08f70d63          	beq	a4,a5,8000435e <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800042c8:	8526                	mv	a0,s1
    800042ca:	c2afe0ef          	jal	800026f4 <iunlock>
  end_op();
    800042ce:	c79fe0ef          	jal	80002f46 <end_op>

  return fd;
    800042d2:	854e                	mv	a0,s3
    800042d4:	74aa                	ld	s1,168(sp)
    800042d6:	790a                	ld	s2,160(sp)
    800042d8:	69ea                	ld	s3,152(sp)
}
    800042da:	70ea                	ld	ra,184(sp)
    800042dc:	744a                	ld	s0,176(sp)
    800042de:	6129                	addi	sp,sp,192
    800042e0:	8082                	ret
      end_op();
    800042e2:	c65fe0ef          	jal	80002f46 <end_op>
      return -1;
    800042e6:	557d                	li	a0,-1
    800042e8:	74aa                	ld	s1,168(sp)
    800042ea:	bfc5                	j	800042da <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800042ec:	f5040513          	addi	a0,s0,-176
    800042f0:	a31fe0ef          	jal	80002d20 <namei>
    800042f4:	84aa                	mv	s1,a0
    800042f6:	c11d                	beqz	a0,8000431c <sys_open+0x10a>
    ilock(ip);
    800042f8:	b4efe0ef          	jal	80002646 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800042fc:	04449703          	lh	a4,68(s1)
    80004300:	4785                	li	a5,1
    80004302:	f4f71de3          	bne	a4,a5,8000425c <sys_open+0x4a>
    80004306:	f4c42783          	lw	a5,-180(s0)
    8000430a:	d3bd                	beqz	a5,80004270 <sys_open+0x5e>
      iunlockput(ip);
    8000430c:	8526                	mv	a0,s1
    8000430e:	d42fe0ef          	jal	80002850 <iunlockput>
      end_op();
    80004312:	c35fe0ef          	jal	80002f46 <end_op>
      return -1;
    80004316:	557d                	li	a0,-1
    80004318:	74aa                	ld	s1,168(sp)
    8000431a:	b7c1                	j	800042da <sys_open+0xc8>
      end_op();
    8000431c:	c2bfe0ef          	jal	80002f46 <end_op>
      return -1;
    80004320:	557d                	li	a0,-1
    80004322:	74aa                	ld	s1,168(sp)
    80004324:	bf5d                	j	800042da <sys_open+0xc8>
    iunlockput(ip);
    80004326:	8526                	mv	a0,s1
    80004328:	d28fe0ef          	jal	80002850 <iunlockput>
    end_op();
    8000432c:	c1bfe0ef          	jal	80002f46 <end_op>
    return -1;
    80004330:	557d                	li	a0,-1
    80004332:	74aa                	ld	s1,168(sp)
    80004334:	b75d                	j	800042da <sys_open+0xc8>
      fileclose(f);
    80004336:	854a                	mv	a0,s2
    80004338:	fbffe0ef          	jal	800032f6 <fileclose>
    8000433c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000433e:	8526                	mv	a0,s1
    80004340:	d10fe0ef          	jal	80002850 <iunlockput>
    end_op();
    80004344:	c03fe0ef          	jal	80002f46 <end_op>
    return -1;
    80004348:	557d                	li	a0,-1
    8000434a:	74aa                	ld	s1,168(sp)
    8000434c:	790a                	ld	s2,160(sp)
    8000434e:	b771                	j	800042da <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004350:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004354:	04649783          	lh	a5,70(s1)
    80004358:	02f91223          	sh	a5,36(s2)
    8000435c:	bf3d                	j	8000429a <sys_open+0x88>
    itrunc(ip);
    8000435e:	8526                	mv	a0,s1
    80004360:	bd4fe0ef          	jal	80002734 <itrunc>
    80004364:	b795                	j	800042c8 <sys_open+0xb6>

0000000080004366 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004366:	7175                	addi	sp,sp,-144
    80004368:	e506                	sd	ra,136(sp)
    8000436a:	e122                	sd	s0,128(sp)
    8000436c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000436e:	b6ffe0ef          	jal	80002edc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004372:	08000613          	li	a2,128
    80004376:	f7040593          	addi	a1,s0,-144
    8000437a:	4501                	li	a0,0
    8000437c:	8d7fd0ef          	jal	80001c52 <argstr>
    80004380:	02054363          	bltz	a0,800043a6 <sys_mkdir+0x40>
    80004384:	4681                	li	a3,0
    80004386:	4601                	li	a2,0
    80004388:	4585                	li	a1,1
    8000438a:	f7040513          	addi	a0,s0,-144
    8000438e:	96fff0ef          	jal	80003cfc <create>
    80004392:	c911                	beqz	a0,800043a6 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004394:	cbcfe0ef          	jal	80002850 <iunlockput>
  end_op();
    80004398:	baffe0ef          	jal	80002f46 <end_op>
  return 0;
    8000439c:	4501                	li	a0,0
}
    8000439e:	60aa                	ld	ra,136(sp)
    800043a0:	640a                	ld	s0,128(sp)
    800043a2:	6149                	addi	sp,sp,144
    800043a4:	8082                	ret
    end_op();
    800043a6:	ba1fe0ef          	jal	80002f46 <end_op>
    return -1;
    800043aa:	557d                	li	a0,-1
    800043ac:	bfcd                	j	8000439e <sys_mkdir+0x38>

00000000800043ae <sys_mknod>:

uint64
sys_mknod(void)
{
    800043ae:	7135                	addi	sp,sp,-160
    800043b0:	ed06                	sd	ra,152(sp)
    800043b2:	e922                	sd	s0,144(sp)
    800043b4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800043b6:	b27fe0ef          	jal	80002edc <begin_op>
  argint(1, &major);
    800043ba:	f6c40593          	addi	a1,s0,-148
    800043be:	4505                	li	a0,1
    800043c0:	85bfd0ef          	jal	80001c1a <argint>
  argint(2, &minor);
    800043c4:	f6840593          	addi	a1,s0,-152
    800043c8:	4509                	li	a0,2
    800043ca:	851fd0ef          	jal	80001c1a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043ce:	08000613          	li	a2,128
    800043d2:	f7040593          	addi	a1,s0,-144
    800043d6:	4501                	li	a0,0
    800043d8:	87bfd0ef          	jal	80001c52 <argstr>
    800043dc:	02054563          	bltz	a0,80004406 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800043e0:	f6841683          	lh	a3,-152(s0)
    800043e4:	f6c41603          	lh	a2,-148(s0)
    800043e8:	458d                	li	a1,3
    800043ea:	f7040513          	addi	a0,s0,-144
    800043ee:	90fff0ef          	jal	80003cfc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043f2:	c911                	beqz	a0,80004406 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800043f4:	c5cfe0ef          	jal	80002850 <iunlockput>
  end_op();
    800043f8:	b4ffe0ef          	jal	80002f46 <end_op>
  return 0;
    800043fc:	4501                	li	a0,0
}
    800043fe:	60ea                	ld	ra,152(sp)
    80004400:	644a                	ld	s0,144(sp)
    80004402:	610d                	addi	sp,sp,160
    80004404:	8082                	ret
    end_op();
    80004406:	b41fe0ef          	jal	80002f46 <end_op>
    return -1;
    8000440a:	557d                	li	a0,-1
    8000440c:	bfcd                	j	800043fe <sys_mknod+0x50>

000000008000440e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000440e:	7135                	addi	sp,sp,-160
    80004410:	ed06                	sd	ra,152(sp)
    80004412:	e922                	sd	s0,144(sp)
    80004414:	e14a                	sd	s2,128(sp)
    80004416:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004418:	94ffc0ef          	jal	80000d66 <myproc>
    8000441c:	892a                	mv	s2,a0
  
  begin_op();
    8000441e:	abffe0ef          	jal	80002edc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004422:	08000613          	li	a2,128
    80004426:	f6040593          	addi	a1,s0,-160
    8000442a:	4501                	li	a0,0
    8000442c:	827fd0ef          	jal	80001c52 <argstr>
    80004430:	04054363          	bltz	a0,80004476 <sys_chdir+0x68>
    80004434:	e526                	sd	s1,136(sp)
    80004436:	f6040513          	addi	a0,s0,-160
    8000443a:	8e7fe0ef          	jal	80002d20 <namei>
    8000443e:	84aa                	mv	s1,a0
    80004440:	c915                	beqz	a0,80004474 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004442:	a04fe0ef          	jal	80002646 <ilock>
  if(ip->type != T_DIR){
    80004446:	04449703          	lh	a4,68(s1)
    8000444a:	4785                	li	a5,1
    8000444c:	02f71963          	bne	a4,a5,8000447e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004450:	8526                	mv	a0,s1
    80004452:	aa2fe0ef          	jal	800026f4 <iunlock>
  iput(p->cwd);
    80004456:	15093503          	ld	a0,336(s2)
    8000445a:	b6efe0ef          	jal	800027c8 <iput>
  end_op();
    8000445e:	ae9fe0ef          	jal	80002f46 <end_op>
  p->cwd = ip;
    80004462:	14993823          	sd	s1,336(s2)
  return 0;
    80004466:	4501                	li	a0,0
    80004468:	64aa                	ld	s1,136(sp)
}
    8000446a:	60ea                	ld	ra,152(sp)
    8000446c:	644a                	ld	s0,144(sp)
    8000446e:	690a                	ld	s2,128(sp)
    80004470:	610d                	addi	sp,sp,160
    80004472:	8082                	ret
    80004474:	64aa                	ld	s1,136(sp)
    end_op();
    80004476:	ad1fe0ef          	jal	80002f46 <end_op>
    return -1;
    8000447a:	557d                	li	a0,-1
    8000447c:	b7fd                	j	8000446a <sys_chdir+0x5c>
    iunlockput(ip);
    8000447e:	8526                	mv	a0,s1
    80004480:	bd0fe0ef          	jal	80002850 <iunlockput>
    end_op();
    80004484:	ac3fe0ef          	jal	80002f46 <end_op>
    return -1;
    80004488:	557d                	li	a0,-1
    8000448a:	64aa                	ld	s1,136(sp)
    8000448c:	bff9                	j	8000446a <sys_chdir+0x5c>

000000008000448e <sys_exec>:

uint64
sys_exec(void)
{
    8000448e:	7121                	addi	sp,sp,-448
    80004490:	ff06                	sd	ra,440(sp)
    80004492:	fb22                	sd	s0,432(sp)
    80004494:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004496:	e4840593          	addi	a1,s0,-440
    8000449a:	4505                	li	a0,1
    8000449c:	f9afd0ef          	jal	80001c36 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800044a0:	08000613          	li	a2,128
    800044a4:	f5040593          	addi	a1,s0,-176
    800044a8:	4501                	li	a0,0
    800044aa:	fa8fd0ef          	jal	80001c52 <argstr>
    800044ae:	87aa                	mv	a5,a0
    return -1;
    800044b0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800044b2:	0c07c463          	bltz	a5,8000457a <sys_exec+0xec>
    800044b6:	f726                	sd	s1,424(sp)
    800044b8:	f34a                	sd	s2,416(sp)
    800044ba:	ef4e                	sd	s3,408(sp)
    800044bc:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800044be:	10000613          	li	a2,256
    800044c2:	4581                	li	a1,0
    800044c4:	e5040513          	addi	a0,s0,-432
    800044c8:	c87fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800044cc:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800044d0:	89a6                	mv	s3,s1
    800044d2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800044d4:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044d8:	00391513          	slli	a0,s2,0x3
    800044dc:	e4040593          	addi	a1,s0,-448
    800044e0:	e4843783          	ld	a5,-440(s0)
    800044e4:	953e                	add	a0,a0,a5
    800044e6:	eaafd0ef          	jal	80001b90 <fetchaddr>
    800044ea:	02054663          	bltz	a0,80004516 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800044ee:	e4043783          	ld	a5,-448(s0)
    800044f2:	c3a9                	beqz	a5,80004534 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800044f4:	c0bfb0ef          	jal	800000fe <kalloc>
    800044f8:	85aa                	mv	a1,a0
    800044fa:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800044fe:	cd01                	beqz	a0,80004516 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004500:	6605                	lui	a2,0x1
    80004502:	e4043503          	ld	a0,-448(s0)
    80004506:	ed4fd0ef          	jal	80001bda <fetchstr>
    8000450a:	00054663          	bltz	a0,80004516 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000450e:	0905                	addi	s2,s2,1
    80004510:	09a1                	addi	s3,s3,8
    80004512:	fd4913e3          	bne	s2,s4,800044d8 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004516:	f5040913          	addi	s2,s0,-176
    8000451a:	6088                	ld	a0,0(s1)
    8000451c:	c931                	beqz	a0,80004570 <sys_exec+0xe2>
    kfree(argv[i]);
    8000451e:	afffb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004522:	04a1                	addi	s1,s1,8
    80004524:	ff249be3          	bne	s1,s2,8000451a <sys_exec+0x8c>
  return -1;
    80004528:	557d                	li	a0,-1
    8000452a:	74ba                	ld	s1,424(sp)
    8000452c:	791a                	ld	s2,416(sp)
    8000452e:	69fa                	ld	s3,408(sp)
    80004530:	6a5a                	ld	s4,400(sp)
    80004532:	a0a1                	j	8000457a <sys_exec+0xec>
      argv[i] = 0;
    80004534:	0009079b          	sext.w	a5,s2
    80004538:	078e                	slli	a5,a5,0x3
    8000453a:	fd078793          	addi	a5,a5,-48
    8000453e:	97a2                	add	a5,a5,s0
    80004540:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004544:	e5040593          	addi	a1,s0,-432
    80004548:	f5040513          	addi	a0,s0,-176
    8000454c:	ba8ff0ef          	jal	800038f4 <exec>
    80004550:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004552:	f5040993          	addi	s3,s0,-176
    80004556:	6088                	ld	a0,0(s1)
    80004558:	c511                	beqz	a0,80004564 <sys_exec+0xd6>
    kfree(argv[i]);
    8000455a:	ac3fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000455e:	04a1                	addi	s1,s1,8
    80004560:	ff349be3          	bne	s1,s3,80004556 <sys_exec+0xc8>
  return ret;
    80004564:	854a                	mv	a0,s2
    80004566:	74ba                	ld	s1,424(sp)
    80004568:	791a                	ld	s2,416(sp)
    8000456a:	69fa                	ld	s3,408(sp)
    8000456c:	6a5a                	ld	s4,400(sp)
    8000456e:	a031                	j	8000457a <sys_exec+0xec>
  return -1;
    80004570:	557d                	li	a0,-1
    80004572:	74ba                	ld	s1,424(sp)
    80004574:	791a                	ld	s2,416(sp)
    80004576:	69fa                	ld	s3,408(sp)
    80004578:	6a5a                	ld	s4,400(sp)
}
    8000457a:	70fa                	ld	ra,440(sp)
    8000457c:	745a                	ld	s0,432(sp)
    8000457e:	6139                	addi	sp,sp,448
    80004580:	8082                	ret

0000000080004582 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004582:	7139                	addi	sp,sp,-64
    80004584:	fc06                	sd	ra,56(sp)
    80004586:	f822                	sd	s0,48(sp)
    80004588:	f426                	sd	s1,40(sp)
    8000458a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000458c:	fdafc0ef          	jal	80000d66 <myproc>
    80004590:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004592:	fd840593          	addi	a1,s0,-40
    80004596:	4501                	li	a0,0
    80004598:	e9efd0ef          	jal	80001c36 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000459c:	fc840593          	addi	a1,s0,-56
    800045a0:	fd040513          	addi	a0,s0,-48
    800045a4:	85cff0ef          	jal	80003600 <pipealloc>
    return -1;
    800045a8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800045aa:	0a054463          	bltz	a0,80004652 <sys_pipe+0xd0>
  fd0 = -1;
    800045ae:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800045b2:	fd043503          	ld	a0,-48(s0)
    800045b6:	f08ff0ef          	jal	80003cbe <fdalloc>
    800045ba:	fca42223          	sw	a0,-60(s0)
    800045be:	08054163          	bltz	a0,80004640 <sys_pipe+0xbe>
    800045c2:	fc843503          	ld	a0,-56(s0)
    800045c6:	ef8ff0ef          	jal	80003cbe <fdalloc>
    800045ca:	fca42023          	sw	a0,-64(s0)
    800045ce:	06054063          	bltz	a0,8000462e <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045d2:	4691                	li	a3,4
    800045d4:	fc440613          	addi	a2,s0,-60
    800045d8:	fd843583          	ld	a1,-40(s0)
    800045dc:	68a8                	ld	a0,80(s1)
    800045de:	bfafc0ef          	jal	800009d8 <copyout>
    800045e2:	00054e63          	bltz	a0,800045fe <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800045e6:	4691                	li	a3,4
    800045e8:	fc040613          	addi	a2,s0,-64
    800045ec:	fd843583          	ld	a1,-40(s0)
    800045f0:	0591                	addi	a1,a1,4
    800045f2:	68a8                	ld	a0,80(s1)
    800045f4:	be4fc0ef          	jal	800009d8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800045f8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045fa:	04055c63          	bgez	a0,80004652 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800045fe:	fc442783          	lw	a5,-60(s0)
    80004602:	07e9                	addi	a5,a5,26
    80004604:	078e                	slli	a5,a5,0x3
    80004606:	97a6                	add	a5,a5,s1
    80004608:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000460c:	fc042783          	lw	a5,-64(s0)
    80004610:	07e9                	addi	a5,a5,26
    80004612:	078e                	slli	a5,a5,0x3
    80004614:	94be                	add	s1,s1,a5
    80004616:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000461a:	fd043503          	ld	a0,-48(s0)
    8000461e:	cd9fe0ef          	jal	800032f6 <fileclose>
    fileclose(wf);
    80004622:	fc843503          	ld	a0,-56(s0)
    80004626:	cd1fe0ef          	jal	800032f6 <fileclose>
    return -1;
    8000462a:	57fd                	li	a5,-1
    8000462c:	a01d                	j	80004652 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000462e:	fc442783          	lw	a5,-60(s0)
    80004632:	0007c763          	bltz	a5,80004640 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004636:	07e9                	addi	a5,a5,26
    80004638:	078e                	slli	a5,a5,0x3
    8000463a:	97a6                	add	a5,a5,s1
    8000463c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004640:	fd043503          	ld	a0,-48(s0)
    80004644:	cb3fe0ef          	jal	800032f6 <fileclose>
    fileclose(wf);
    80004648:	fc843503          	ld	a0,-56(s0)
    8000464c:	cabfe0ef          	jal	800032f6 <fileclose>
    return -1;
    80004650:	57fd                	li	a5,-1
}
    80004652:	853e                	mv	a0,a5
    80004654:	70e2                	ld	ra,56(sp)
    80004656:	7442                	ld	s0,48(sp)
    80004658:	74a2                	ld	s1,40(sp)
    8000465a:	6121                	addi	sp,sp,64
    8000465c:	8082                	ret
	...

0000000080004660 <kernelvec>:
    80004660:	7111                	addi	sp,sp,-256
    80004662:	e006                	sd	ra,0(sp)
    80004664:	e40a                	sd	sp,8(sp)
    80004666:	e80e                	sd	gp,16(sp)
    80004668:	ec12                	sd	tp,24(sp)
    8000466a:	f016                	sd	t0,32(sp)
    8000466c:	f41a                	sd	t1,40(sp)
    8000466e:	f81e                	sd	t2,48(sp)
    80004670:	e4aa                	sd	a0,72(sp)
    80004672:	e8ae                	sd	a1,80(sp)
    80004674:	ecb2                	sd	a2,88(sp)
    80004676:	f0b6                	sd	a3,96(sp)
    80004678:	f4ba                	sd	a4,104(sp)
    8000467a:	f8be                	sd	a5,112(sp)
    8000467c:	fcc2                	sd	a6,120(sp)
    8000467e:	e146                	sd	a7,128(sp)
    80004680:	edf2                	sd	t3,216(sp)
    80004682:	f1f6                	sd	t4,224(sp)
    80004684:	f5fa                	sd	t5,232(sp)
    80004686:	f9fe                	sd	t6,240(sp)
    80004688:	c18fd0ef          	jal	80001aa0 <kerneltrap>
    8000468c:	6082                	ld	ra,0(sp)
    8000468e:	6122                	ld	sp,8(sp)
    80004690:	61c2                	ld	gp,16(sp)
    80004692:	7282                	ld	t0,32(sp)
    80004694:	7322                	ld	t1,40(sp)
    80004696:	73c2                	ld	t2,48(sp)
    80004698:	6526                	ld	a0,72(sp)
    8000469a:	65c6                	ld	a1,80(sp)
    8000469c:	6666                	ld	a2,88(sp)
    8000469e:	7686                	ld	a3,96(sp)
    800046a0:	7726                	ld	a4,104(sp)
    800046a2:	77c6                	ld	a5,112(sp)
    800046a4:	7866                	ld	a6,120(sp)
    800046a6:	688a                	ld	a7,128(sp)
    800046a8:	6e6e                	ld	t3,216(sp)
    800046aa:	7e8e                	ld	t4,224(sp)
    800046ac:	7f2e                	ld	t5,232(sp)
    800046ae:	7fce                	ld	t6,240(sp)
    800046b0:	6111                	addi	sp,sp,256
    800046b2:	10200073          	sret
	...

00000000800046be <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800046be:	1141                	addi	sp,sp,-16
    800046c0:	e422                	sd	s0,8(sp)
    800046c2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800046c4:	0c0007b7          	lui	a5,0xc000
    800046c8:	4705                	li	a4,1
    800046ca:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800046cc:	0c0007b7          	lui	a5,0xc000
    800046d0:	c3d8                	sw	a4,4(a5)
}
    800046d2:	6422                	ld	s0,8(sp)
    800046d4:	0141                	addi	sp,sp,16
    800046d6:	8082                	ret

00000000800046d8 <plicinithart>:

void
plicinithart(void)
{
    800046d8:	1141                	addi	sp,sp,-16
    800046da:	e406                	sd	ra,8(sp)
    800046dc:	e022                	sd	s0,0(sp)
    800046de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800046e0:	e5afc0ef          	jal	80000d3a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800046e4:	0085171b          	slliw	a4,a0,0x8
    800046e8:	0c0027b7          	lui	a5,0xc002
    800046ec:	97ba                	add	a5,a5,a4
    800046ee:	40200713          	li	a4,1026
    800046f2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800046f6:	00d5151b          	slliw	a0,a0,0xd
    800046fa:	0c2017b7          	lui	a5,0xc201
    800046fe:	97aa                	add	a5,a5,a0
    80004700:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004704:	60a2                	ld	ra,8(sp)
    80004706:	6402                	ld	s0,0(sp)
    80004708:	0141                	addi	sp,sp,16
    8000470a:	8082                	ret

000000008000470c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000470c:	1141                	addi	sp,sp,-16
    8000470e:	e406                	sd	ra,8(sp)
    80004710:	e022                	sd	s0,0(sp)
    80004712:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004714:	e26fc0ef          	jal	80000d3a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004718:	00d5151b          	slliw	a0,a0,0xd
    8000471c:	0c2017b7          	lui	a5,0xc201
    80004720:	97aa                	add	a5,a5,a0
  return irq;
}
    80004722:	43c8                	lw	a0,4(a5)
    80004724:	60a2                	ld	ra,8(sp)
    80004726:	6402                	ld	s0,0(sp)
    80004728:	0141                	addi	sp,sp,16
    8000472a:	8082                	ret

000000008000472c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000472c:	1101                	addi	sp,sp,-32
    8000472e:	ec06                	sd	ra,24(sp)
    80004730:	e822                	sd	s0,16(sp)
    80004732:	e426                	sd	s1,8(sp)
    80004734:	1000                	addi	s0,sp,32
    80004736:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004738:	e02fc0ef          	jal	80000d3a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000473c:	00d5151b          	slliw	a0,a0,0xd
    80004740:	0c2017b7          	lui	a5,0xc201
    80004744:	97aa                	add	a5,a5,a0
    80004746:	c3c4                	sw	s1,4(a5)
}
    80004748:	60e2                	ld	ra,24(sp)
    8000474a:	6442                	ld	s0,16(sp)
    8000474c:	64a2                	ld	s1,8(sp)
    8000474e:	6105                	addi	sp,sp,32
    80004750:	8082                	ret

0000000080004752 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004752:	1141                	addi	sp,sp,-16
    80004754:	e406                	sd	ra,8(sp)
    80004756:	e022                	sd	s0,0(sp)
    80004758:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000475a:	479d                	li	a5,7
    8000475c:	04a7ca63          	blt	a5,a0,800047b0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004760:	00014797          	auipc	a5,0x14
    80004764:	29078793          	addi	a5,a5,656 # 800189f0 <disk>
    80004768:	97aa                	add	a5,a5,a0
    8000476a:	0187c783          	lbu	a5,24(a5)
    8000476e:	e7b9                	bnez	a5,800047bc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004770:	00451693          	slli	a3,a0,0x4
    80004774:	00014797          	auipc	a5,0x14
    80004778:	27c78793          	addi	a5,a5,636 # 800189f0 <disk>
    8000477c:	6398                	ld	a4,0(a5)
    8000477e:	9736                	add	a4,a4,a3
    80004780:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004784:	6398                	ld	a4,0(a5)
    80004786:	9736                	add	a4,a4,a3
    80004788:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000478c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004790:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004794:	97aa                	add	a5,a5,a0
    80004796:	4705                	li	a4,1
    80004798:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000479c:	00014517          	auipc	a0,0x14
    800047a0:	26c50513          	addi	a0,a0,620 # 80018a08 <disk+0x18>
    800047a4:	bddfc0ef          	jal	80001380 <wakeup>
}
    800047a8:	60a2                	ld	ra,8(sp)
    800047aa:	6402                	ld	s0,0(sp)
    800047ac:	0141                	addi	sp,sp,16
    800047ae:	8082                	ret
    panic("free_desc 1");
    800047b0:	00003517          	auipc	a0,0x3
    800047b4:	e6050513          	addi	a0,a0,-416 # 80007610 <etext+0x610>
    800047b8:	43b000ef          	jal	800053f2 <panic>
    panic("free_desc 2");
    800047bc:	00003517          	auipc	a0,0x3
    800047c0:	e6450513          	addi	a0,a0,-412 # 80007620 <etext+0x620>
    800047c4:	42f000ef          	jal	800053f2 <panic>

00000000800047c8 <virtio_disk_init>:
{
    800047c8:	1101                	addi	sp,sp,-32
    800047ca:	ec06                	sd	ra,24(sp)
    800047cc:	e822                	sd	s0,16(sp)
    800047ce:	e426                	sd	s1,8(sp)
    800047d0:	e04a                	sd	s2,0(sp)
    800047d2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800047d4:	00003597          	auipc	a1,0x3
    800047d8:	e5c58593          	addi	a1,a1,-420 # 80007630 <etext+0x630>
    800047dc:	00014517          	auipc	a0,0x14
    800047e0:	33c50513          	addi	a0,a0,828 # 80018b18 <disk+0x128>
    800047e4:	6bd000ef          	jal	800056a0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800047e8:	100017b7          	lui	a5,0x10001
    800047ec:	4398                	lw	a4,0(a5)
    800047ee:	2701                	sext.w	a4,a4
    800047f0:	747277b7          	lui	a5,0x74727
    800047f4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800047f8:	18f71063          	bne	a4,a5,80004978 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800047fc:	100017b7          	lui	a5,0x10001
    80004800:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004802:	439c                	lw	a5,0(a5)
    80004804:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004806:	4709                	li	a4,2
    80004808:	16e79863          	bne	a5,a4,80004978 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000480c:	100017b7          	lui	a5,0x10001
    80004810:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004812:	439c                	lw	a5,0(a5)
    80004814:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004816:	16e79163          	bne	a5,a4,80004978 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000481a:	100017b7          	lui	a5,0x10001
    8000481e:	47d8                	lw	a4,12(a5)
    80004820:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004822:	554d47b7          	lui	a5,0x554d4
    80004826:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000482a:	14f71763          	bne	a4,a5,80004978 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000482e:	100017b7          	lui	a5,0x10001
    80004832:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004836:	4705                	li	a4,1
    80004838:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000483a:	470d                	li	a4,3
    8000483c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000483e:	10001737          	lui	a4,0x10001
    80004842:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004844:	c7ffe737          	lui	a4,0xc7ffe
    80004848:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fddb2f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000484c:	8ef9                	and	a3,a3,a4
    8000484e:	10001737          	lui	a4,0x10001
    80004852:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004854:	472d                	li	a4,11
    80004856:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004858:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000485c:	439c                	lw	a5,0(a5)
    8000485e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004862:	8ba1                	andi	a5,a5,8
    80004864:	12078063          	beqz	a5,80004984 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004868:	100017b7          	lui	a5,0x10001
    8000486c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004870:	100017b7          	lui	a5,0x10001
    80004874:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004878:	439c                	lw	a5,0(a5)
    8000487a:	2781                	sext.w	a5,a5
    8000487c:	10079a63          	bnez	a5,80004990 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004880:	100017b7          	lui	a5,0x10001
    80004884:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004888:	439c                	lw	a5,0(a5)
    8000488a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000488c:	10078863          	beqz	a5,8000499c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004890:	471d                	li	a4,7
    80004892:	10f77b63          	bgeu	a4,a5,800049a8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004896:	869fb0ef          	jal	800000fe <kalloc>
    8000489a:	00014497          	auipc	s1,0x14
    8000489e:	15648493          	addi	s1,s1,342 # 800189f0 <disk>
    800048a2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800048a4:	85bfb0ef          	jal	800000fe <kalloc>
    800048a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800048aa:	855fb0ef          	jal	800000fe <kalloc>
    800048ae:	87aa                	mv	a5,a0
    800048b0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800048b2:	6088                	ld	a0,0(s1)
    800048b4:	10050063          	beqz	a0,800049b4 <virtio_disk_init+0x1ec>
    800048b8:	00014717          	auipc	a4,0x14
    800048bc:	14073703          	ld	a4,320(a4) # 800189f8 <disk+0x8>
    800048c0:	0e070a63          	beqz	a4,800049b4 <virtio_disk_init+0x1ec>
    800048c4:	0e078863          	beqz	a5,800049b4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800048c8:	6605                	lui	a2,0x1
    800048ca:	4581                	li	a1,0
    800048cc:	883fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    800048d0:	00014497          	auipc	s1,0x14
    800048d4:	12048493          	addi	s1,s1,288 # 800189f0 <disk>
    800048d8:	6605                	lui	a2,0x1
    800048da:	4581                	li	a1,0
    800048dc:	6488                	ld	a0,8(s1)
    800048de:	871fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    800048e2:	6605                	lui	a2,0x1
    800048e4:	4581                	li	a1,0
    800048e6:	6888                	ld	a0,16(s1)
    800048e8:	867fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800048ec:	100017b7          	lui	a5,0x10001
    800048f0:	4721                	li	a4,8
    800048f2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800048f4:	4098                	lw	a4,0(s1)
    800048f6:	100017b7          	lui	a5,0x10001
    800048fa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800048fe:	40d8                	lw	a4,4(s1)
    80004900:	100017b7          	lui	a5,0x10001
    80004904:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004908:	649c                	ld	a5,8(s1)
    8000490a:	0007869b          	sext.w	a3,a5
    8000490e:	10001737          	lui	a4,0x10001
    80004912:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004916:	9781                	srai	a5,a5,0x20
    80004918:	10001737          	lui	a4,0x10001
    8000491c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004920:	689c                	ld	a5,16(s1)
    80004922:	0007869b          	sext.w	a3,a5
    80004926:	10001737          	lui	a4,0x10001
    8000492a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000492e:	9781                	srai	a5,a5,0x20
    80004930:	10001737          	lui	a4,0x10001
    80004934:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004938:	10001737          	lui	a4,0x10001
    8000493c:	4785                	li	a5,1
    8000493e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004940:	00f48c23          	sb	a5,24(s1)
    80004944:	00f48ca3          	sb	a5,25(s1)
    80004948:	00f48d23          	sb	a5,26(s1)
    8000494c:	00f48da3          	sb	a5,27(s1)
    80004950:	00f48e23          	sb	a5,28(s1)
    80004954:	00f48ea3          	sb	a5,29(s1)
    80004958:	00f48f23          	sb	a5,30(s1)
    8000495c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004960:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004964:	100017b7          	lui	a5,0x10001
    80004968:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000496c:	60e2                	ld	ra,24(sp)
    8000496e:	6442                	ld	s0,16(sp)
    80004970:	64a2                	ld	s1,8(sp)
    80004972:	6902                	ld	s2,0(sp)
    80004974:	6105                	addi	sp,sp,32
    80004976:	8082                	ret
    panic("could not find virtio disk");
    80004978:	00003517          	auipc	a0,0x3
    8000497c:	cc850513          	addi	a0,a0,-824 # 80007640 <etext+0x640>
    80004980:	273000ef          	jal	800053f2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004984:	00003517          	auipc	a0,0x3
    80004988:	cdc50513          	addi	a0,a0,-804 # 80007660 <etext+0x660>
    8000498c:	267000ef          	jal	800053f2 <panic>
    panic("virtio disk should not be ready");
    80004990:	00003517          	auipc	a0,0x3
    80004994:	cf050513          	addi	a0,a0,-784 # 80007680 <etext+0x680>
    80004998:	25b000ef          	jal	800053f2 <panic>
    panic("virtio disk has no queue 0");
    8000499c:	00003517          	auipc	a0,0x3
    800049a0:	d0450513          	addi	a0,a0,-764 # 800076a0 <etext+0x6a0>
    800049a4:	24f000ef          	jal	800053f2 <panic>
    panic("virtio disk max queue too short");
    800049a8:	00003517          	auipc	a0,0x3
    800049ac:	d1850513          	addi	a0,a0,-744 # 800076c0 <etext+0x6c0>
    800049b0:	243000ef          	jal	800053f2 <panic>
    panic("virtio disk kalloc");
    800049b4:	00003517          	auipc	a0,0x3
    800049b8:	d2c50513          	addi	a0,a0,-724 # 800076e0 <etext+0x6e0>
    800049bc:	237000ef          	jal	800053f2 <panic>

00000000800049c0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800049c0:	7159                	addi	sp,sp,-112
    800049c2:	f486                	sd	ra,104(sp)
    800049c4:	f0a2                	sd	s0,96(sp)
    800049c6:	eca6                	sd	s1,88(sp)
    800049c8:	e8ca                	sd	s2,80(sp)
    800049ca:	e4ce                	sd	s3,72(sp)
    800049cc:	e0d2                	sd	s4,64(sp)
    800049ce:	fc56                	sd	s5,56(sp)
    800049d0:	f85a                	sd	s6,48(sp)
    800049d2:	f45e                	sd	s7,40(sp)
    800049d4:	f062                	sd	s8,32(sp)
    800049d6:	ec66                	sd	s9,24(sp)
    800049d8:	1880                	addi	s0,sp,112
    800049da:	8a2a                	mv	s4,a0
    800049dc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800049de:	00c52c83          	lw	s9,12(a0)
    800049e2:	001c9c9b          	slliw	s9,s9,0x1
    800049e6:	1c82                	slli	s9,s9,0x20
    800049e8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800049ec:	00014517          	auipc	a0,0x14
    800049f0:	12c50513          	addi	a0,a0,300 # 80018b18 <disk+0x128>
    800049f4:	52d000ef          	jal	80005720 <acquire>
  for(int i = 0; i < 3; i++){
    800049f8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800049fa:	44a1                	li	s1,8
      disk.free[i] = 0;
    800049fc:	00014b17          	auipc	s6,0x14
    80004a00:	ff4b0b13          	addi	s6,s6,-12 # 800189f0 <disk>
  for(int i = 0; i < 3; i++){
    80004a04:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a06:	00014c17          	auipc	s8,0x14
    80004a0a:	112c0c13          	addi	s8,s8,274 # 80018b18 <disk+0x128>
    80004a0e:	a8b9                	j	80004a6c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004a10:	00fb0733          	add	a4,s6,a5
    80004a14:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004a18:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004a1a:	0207c563          	bltz	a5,80004a44 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004a1e:	2905                	addiw	s2,s2,1
    80004a20:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004a22:	05590963          	beq	s2,s5,80004a74 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004a26:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004a28:	00014717          	auipc	a4,0x14
    80004a2c:	fc870713          	addi	a4,a4,-56 # 800189f0 <disk>
    80004a30:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004a32:	01874683          	lbu	a3,24(a4)
    80004a36:	fee9                	bnez	a3,80004a10 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004a38:	2785                	addiw	a5,a5,1
    80004a3a:	0705                	addi	a4,a4,1
    80004a3c:	fe979be3          	bne	a5,s1,80004a32 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004a40:	57fd                	li	a5,-1
    80004a42:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004a44:	01205d63          	blez	s2,80004a5e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004a48:	f9042503          	lw	a0,-112(s0)
    80004a4c:	d07ff0ef          	jal	80004752 <free_desc>
      for(int j = 0; j < i; j++)
    80004a50:	4785                	li	a5,1
    80004a52:	0127d663          	bge	a5,s2,80004a5e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004a56:	f9442503          	lw	a0,-108(s0)
    80004a5a:	cf9ff0ef          	jal	80004752 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a5e:	85e2                	mv	a1,s8
    80004a60:	00014517          	auipc	a0,0x14
    80004a64:	fa850513          	addi	a0,a0,-88 # 80018a08 <disk+0x18>
    80004a68:	8cdfc0ef          	jal	80001334 <sleep>
  for(int i = 0; i < 3; i++){
    80004a6c:	f9040613          	addi	a2,s0,-112
    80004a70:	894e                	mv	s2,s3
    80004a72:	bf55                	j	80004a26 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a74:	f9042503          	lw	a0,-112(s0)
    80004a78:	00451693          	slli	a3,a0,0x4

  if(write)
    80004a7c:	00014797          	auipc	a5,0x14
    80004a80:	f7478793          	addi	a5,a5,-140 # 800189f0 <disk>
    80004a84:	00a50713          	addi	a4,a0,10
    80004a88:	0712                	slli	a4,a4,0x4
    80004a8a:	973e                	add	a4,a4,a5
    80004a8c:	01703633          	snez	a2,s7
    80004a90:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004a92:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004a96:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004a9a:	6398                	ld	a4,0(a5)
    80004a9c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a9e:	0a868613          	addi	a2,a3,168
    80004aa2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004aa4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004aa6:	6390                	ld	a2,0(a5)
    80004aa8:	00d605b3          	add	a1,a2,a3
    80004aac:	4741                	li	a4,16
    80004aae:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004ab0:	4805                	li	a6,1
    80004ab2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004ab6:	f9442703          	lw	a4,-108(s0)
    80004aba:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004abe:	0712                	slli	a4,a4,0x4
    80004ac0:	963a                	add	a2,a2,a4
    80004ac2:	058a0593          	addi	a1,s4,88
    80004ac6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ac8:	0007b883          	ld	a7,0(a5)
    80004acc:	9746                	add	a4,a4,a7
    80004ace:	40000613          	li	a2,1024
    80004ad2:	c710                	sw	a2,8(a4)
  if(write)
    80004ad4:	001bb613          	seqz	a2,s7
    80004ad8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004adc:	00166613          	ori	a2,a2,1
    80004ae0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ae4:	f9842583          	lw	a1,-104(s0)
    80004ae8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004aec:	00250613          	addi	a2,a0,2
    80004af0:	0612                	slli	a2,a2,0x4
    80004af2:	963e                	add	a2,a2,a5
    80004af4:	577d                	li	a4,-1
    80004af6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004afa:	0592                	slli	a1,a1,0x4
    80004afc:	98ae                	add	a7,a7,a1
    80004afe:	03068713          	addi	a4,a3,48
    80004b02:	973e                	add	a4,a4,a5
    80004b04:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004b08:	6398                	ld	a4,0(a5)
    80004b0a:	972e                	add	a4,a4,a1
    80004b0c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004b10:	4689                	li	a3,2
    80004b12:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004b16:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004b1a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004b1e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004b22:	6794                	ld	a3,8(a5)
    80004b24:	0026d703          	lhu	a4,2(a3)
    80004b28:	8b1d                	andi	a4,a4,7
    80004b2a:	0706                	slli	a4,a4,0x1
    80004b2c:	96ba                	add	a3,a3,a4
    80004b2e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004b32:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004b36:	6798                	ld	a4,8(a5)
    80004b38:	00275783          	lhu	a5,2(a4)
    80004b3c:	2785                	addiw	a5,a5,1
    80004b3e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004b42:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004b46:	100017b7          	lui	a5,0x10001
    80004b4a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004b4e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004b52:	00014917          	auipc	s2,0x14
    80004b56:	fc690913          	addi	s2,s2,-58 # 80018b18 <disk+0x128>
  while(b->disk == 1) {
    80004b5a:	4485                	li	s1,1
    80004b5c:	01079a63          	bne	a5,a6,80004b70 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004b60:	85ca                	mv	a1,s2
    80004b62:	8552                	mv	a0,s4
    80004b64:	fd0fc0ef          	jal	80001334 <sleep>
  while(b->disk == 1) {
    80004b68:	004a2783          	lw	a5,4(s4)
    80004b6c:	fe978ae3          	beq	a5,s1,80004b60 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004b70:	f9042903          	lw	s2,-112(s0)
    80004b74:	00290713          	addi	a4,s2,2
    80004b78:	0712                	slli	a4,a4,0x4
    80004b7a:	00014797          	auipc	a5,0x14
    80004b7e:	e7678793          	addi	a5,a5,-394 # 800189f0 <disk>
    80004b82:	97ba                	add	a5,a5,a4
    80004b84:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004b88:	00014997          	auipc	s3,0x14
    80004b8c:	e6898993          	addi	s3,s3,-408 # 800189f0 <disk>
    80004b90:	00491713          	slli	a4,s2,0x4
    80004b94:	0009b783          	ld	a5,0(s3)
    80004b98:	97ba                	add	a5,a5,a4
    80004b9a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004b9e:	854a                	mv	a0,s2
    80004ba0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004ba4:	bafff0ef          	jal	80004752 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004ba8:	8885                	andi	s1,s1,1
    80004baa:	f0fd                	bnez	s1,80004b90 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004bac:	00014517          	auipc	a0,0x14
    80004bb0:	f6c50513          	addi	a0,a0,-148 # 80018b18 <disk+0x128>
    80004bb4:	405000ef          	jal	800057b8 <release>
}
    80004bb8:	70a6                	ld	ra,104(sp)
    80004bba:	7406                	ld	s0,96(sp)
    80004bbc:	64e6                	ld	s1,88(sp)
    80004bbe:	6946                	ld	s2,80(sp)
    80004bc0:	69a6                	ld	s3,72(sp)
    80004bc2:	6a06                	ld	s4,64(sp)
    80004bc4:	7ae2                	ld	s5,56(sp)
    80004bc6:	7b42                	ld	s6,48(sp)
    80004bc8:	7ba2                	ld	s7,40(sp)
    80004bca:	7c02                	ld	s8,32(sp)
    80004bcc:	6ce2                	ld	s9,24(sp)
    80004bce:	6165                	addi	sp,sp,112
    80004bd0:	8082                	ret

0000000080004bd2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004bd2:	1101                	addi	sp,sp,-32
    80004bd4:	ec06                	sd	ra,24(sp)
    80004bd6:	e822                	sd	s0,16(sp)
    80004bd8:	e426                	sd	s1,8(sp)
    80004bda:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004bdc:	00014497          	auipc	s1,0x14
    80004be0:	e1448493          	addi	s1,s1,-492 # 800189f0 <disk>
    80004be4:	00014517          	auipc	a0,0x14
    80004be8:	f3450513          	addi	a0,a0,-204 # 80018b18 <disk+0x128>
    80004bec:	335000ef          	jal	80005720 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004bf0:	100017b7          	lui	a5,0x10001
    80004bf4:	53b8                	lw	a4,96(a5)
    80004bf6:	8b0d                	andi	a4,a4,3
    80004bf8:	100017b7          	lui	a5,0x10001
    80004bfc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004bfe:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004c02:	689c                	ld	a5,16(s1)
    80004c04:	0204d703          	lhu	a4,32(s1)
    80004c08:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004c0c:	04f70663          	beq	a4,a5,80004c58 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004c10:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004c14:	6898                	ld	a4,16(s1)
    80004c16:	0204d783          	lhu	a5,32(s1)
    80004c1a:	8b9d                	andi	a5,a5,7
    80004c1c:	078e                	slli	a5,a5,0x3
    80004c1e:	97ba                	add	a5,a5,a4
    80004c20:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004c22:	00278713          	addi	a4,a5,2
    80004c26:	0712                	slli	a4,a4,0x4
    80004c28:	9726                	add	a4,a4,s1
    80004c2a:	01074703          	lbu	a4,16(a4)
    80004c2e:	e321                	bnez	a4,80004c6e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004c30:	0789                	addi	a5,a5,2
    80004c32:	0792                	slli	a5,a5,0x4
    80004c34:	97a6                	add	a5,a5,s1
    80004c36:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004c38:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004c3c:	f44fc0ef          	jal	80001380 <wakeup>

    disk.used_idx += 1;
    80004c40:	0204d783          	lhu	a5,32(s1)
    80004c44:	2785                	addiw	a5,a5,1
    80004c46:	17c2                	slli	a5,a5,0x30
    80004c48:	93c1                	srli	a5,a5,0x30
    80004c4a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004c4e:	6898                	ld	a4,16(s1)
    80004c50:	00275703          	lhu	a4,2(a4)
    80004c54:	faf71ee3          	bne	a4,a5,80004c10 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004c58:	00014517          	auipc	a0,0x14
    80004c5c:	ec050513          	addi	a0,a0,-320 # 80018b18 <disk+0x128>
    80004c60:	359000ef          	jal	800057b8 <release>
}
    80004c64:	60e2                	ld	ra,24(sp)
    80004c66:	6442                	ld	s0,16(sp)
    80004c68:	64a2                	ld	s1,8(sp)
    80004c6a:	6105                	addi	sp,sp,32
    80004c6c:	8082                	ret
      panic("virtio_disk_intr status");
    80004c6e:	00003517          	auipc	a0,0x3
    80004c72:	a8a50513          	addi	a0,a0,-1398 # 800076f8 <etext+0x6f8>
    80004c76:	77c000ef          	jal	800053f2 <panic>

0000000080004c7a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004c7a:	1141                	addi	sp,sp,-16
    80004c7c:	e422                	sd	s0,8(sp)
    80004c7e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004c80:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004c84:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004c88:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004c8c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004c90:	577d                	li	a4,-1
    80004c92:	177e                	slli	a4,a4,0x3f
    80004c94:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004c96:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004c9a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004c9e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004ca2:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004ca6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004caa:	000f4737          	lui	a4,0xf4
    80004cae:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004cb2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004cb4:	14d79073          	csrw	stimecmp,a5
}
    80004cb8:	6422                	ld	s0,8(sp)
    80004cba:	0141                	addi	sp,sp,16
    80004cbc:	8082                	ret

0000000080004cbe <start>:
{
    80004cbe:	1141                	addi	sp,sp,-16
    80004cc0:	e406                	sd	ra,8(sp)
    80004cc2:	e022                	sd	s0,0(sp)
    80004cc4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004cc6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004cca:	7779                	lui	a4,0xffffe
    80004ccc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddbcf>
    80004cd0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004cd2:	6705                	lui	a4,0x1
    80004cd4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004cd8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004cda:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004cde:	ffffb797          	auipc	a5,0xffffb
    80004ce2:	60a78793          	addi	a5,a5,1546 # 800002e8 <main>
    80004ce6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004cea:	4781                	li	a5,0
    80004cec:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004cf0:	67c1                	lui	a5,0x10
    80004cf2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004cf4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004cf8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004cfc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004d00:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004d04:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004d08:	57fd                	li	a5,-1
    80004d0a:	83a9                	srli	a5,a5,0xa
    80004d0c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004d10:	47bd                	li	a5,15
    80004d12:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004d16:	f65ff0ef          	jal	80004c7a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004d1a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004d1e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004d20:	823e                	mv	tp,a5
  asm volatile("mret");
    80004d22:	30200073          	mret
}
    80004d26:	60a2                	ld	ra,8(sp)
    80004d28:	6402                	ld	s0,0(sp)
    80004d2a:	0141                	addi	sp,sp,16
    80004d2c:	8082                	ret

0000000080004d2e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004d2e:	715d                	addi	sp,sp,-80
    80004d30:	e486                	sd	ra,72(sp)
    80004d32:	e0a2                	sd	s0,64(sp)
    80004d34:	f84a                	sd	s2,48(sp)
    80004d36:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004d38:	04c05263          	blez	a2,80004d7c <consolewrite+0x4e>
    80004d3c:	fc26                	sd	s1,56(sp)
    80004d3e:	f44e                	sd	s3,40(sp)
    80004d40:	f052                	sd	s4,32(sp)
    80004d42:	ec56                	sd	s5,24(sp)
    80004d44:	8a2a                	mv	s4,a0
    80004d46:	84ae                	mv	s1,a1
    80004d48:	89b2                	mv	s3,a2
    80004d4a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004d4c:	5afd                	li	s5,-1
    80004d4e:	4685                	li	a3,1
    80004d50:	8626                	mv	a2,s1
    80004d52:	85d2                	mv	a1,s4
    80004d54:	fbf40513          	addi	a0,s0,-65
    80004d58:	983fc0ef          	jal	800016da <either_copyin>
    80004d5c:	03550263          	beq	a0,s5,80004d80 <consolewrite+0x52>
      break;
    uartputc(c);
    80004d60:	fbf44503          	lbu	a0,-65(s0)
    80004d64:	035000ef          	jal	80005598 <uartputc>
  for(i = 0; i < n; i++){
    80004d68:	2905                	addiw	s2,s2,1
    80004d6a:	0485                	addi	s1,s1,1
    80004d6c:	ff2991e3          	bne	s3,s2,80004d4e <consolewrite+0x20>
    80004d70:	894e                	mv	s2,s3
    80004d72:	74e2                	ld	s1,56(sp)
    80004d74:	79a2                	ld	s3,40(sp)
    80004d76:	7a02                	ld	s4,32(sp)
    80004d78:	6ae2                	ld	s5,24(sp)
    80004d7a:	a039                	j	80004d88 <consolewrite+0x5a>
    80004d7c:	4901                	li	s2,0
    80004d7e:	a029                	j	80004d88 <consolewrite+0x5a>
    80004d80:	74e2                	ld	s1,56(sp)
    80004d82:	79a2                	ld	s3,40(sp)
    80004d84:	7a02                	ld	s4,32(sp)
    80004d86:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004d88:	854a                	mv	a0,s2
    80004d8a:	60a6                	ld	ra,72(sp)
    80004d8c:	6406                	ld	s0,64(sp)
    80004d8e:	7942                	ld	s2,48(sp)
    80004d90:	6161                	addi	sp,sp,80
    80004d92:	8082                	ret

0000000080004d94 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004d94:	711d                	addi	sp,sp,-96
    80004d96:	ec86                	sd	ra,88(sp)
    80004d98:	e8a2                	sd	s0,80(sp)
    80004d9a:	e4a6                	sd	s1,72(sp)
    80004d9c:	e0ca                	sd	s2,64(sp)
    80004d9e:	fc4e                	sd	s3,56(sp)
    80004da0:	f852                	sd	s4,48(sp)
    80004da2:	f456                	sd	s5,40(sp)
    80004da4:	f05a                	sd	s6,32(sp)
    80004da6:	1080                	addi	s0,sp,96
    80004da8:	8aaa                	mv	s5,a0
    80004daa:	8a2e                	mv	s4,a1
    80004dac:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004dae:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004db2:	0001c517          	auipc	a0,0x1c
    80004db6:	d7e50513          	addi	a0,a0,-642 # 80020b30 <cons>
    80004dba:	167000ef          	jal	80005720 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004dbe:	0001c497          	auipc	s1,0x1c
    80004dc2:	d7248493          	addi	s1,s1,-654 # 80020b30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004dc6:	0001c917          	auipc	s2,0x1c
    80004dca:	e0290913          	addi	s2,s2,-510 # 80020bc8 <cons+0x98>
  while(n > 0){
    80004dce:	0b305d63          	blez	s3,80004e88 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004dd2:	0984a783          	lw	a5,152(s1)
    80004dd6:	09c4a703          	lw	a4,156(s1)
    80004dda:	0af71263          	bne	a4,a5,80004e7e <consoleread+0xea>
      if(killed(myproc())){
    80004dde:	f89fb0ef          	jal	80000d66 <myproc>
    80004de2:	f8afc0ef          	jal	8000156c <killed>
    80004de6:	e12d                	bnez	a0,80004e48 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004de8:	85a6                	mv	a1,s1
    80004dea:	854a                	mv	a0,s2
    80004dec:	d48fc0ef          	jal	80001334 <sleep>
    while(cons.r == cons.w){
    80004df0:	0984a783          	lw	a5,152(s1)
    80004df4:	09c4a703          	lw	a4,156(s1)
    80004df8:	fef703e3          	beq	a4,a5,80004dde <consoleread+0x4a>
    80004dfc:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004dfe:	0001c717          	auipc	a4,0x1c
    80004e02:	d3270713          	addi	a4,a4,-718 # 80020b30 <cons>
    80004e06:	0017869b          	addiw	a3,a5,1
    80004e0a:	08d72c23          	sw	a3,152(a4)
    80004e0e:	07f7f693          	andi	a3,a5,127
    80004e12:	9736                	add	a4,a4,a3
    80004e14:	01874703          	lbu	a4,24(a4)
    80004e18:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004e1c:	4691                	li	a3,4
    80004e1e:	04db8663          	beq	s7,a3,80004e6a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004e22:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e26:	4685                	li	a3,1
    80004e28:	faf40613          	addi	a2,s0,-81
    80004e2c:	85d2                	mv	a1,s4
    80004e2e:	8556                	mv	a0,s5
    80004e30:	861fc0ef          	jal	80001690 <either_copyout>
    80004e34:	57fd                	li	a5,-1
    80004e36:	04f50863          	beq	a0,a5,80004e86 <consoleread+0xf2>
      break;

    dst++;
    80004e3a:	0a05                	addi	s4,s4,1
    --n;
    80004e3c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004e3e:	47a9                	li	a5,10
    80004e40:	04fb8d63          	beq	s7,a5,80004e9a <consoleread+0x106>
    80004e44:	6be2                	ld	s7,24(sp)
    80004e46:	b761                	j	80004dce <consoleread+0x3a>
        release(&cons.lock);
    80004e48:	0001c517          	auipc	a0,0x1c
    80004e4c:	ce850513          	addi	a0,a0,-792 # 80020b30 <cons>
    80004e50:	169000ef          	jal	800057b8 <release>
        return -1;
    80004e54:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004e56:	60e6                	ld	ra,88(sp)
    80004e58:	6446                	ld	s0,80(sp)
    80004e5a:	64a6                	ld	s1,72(sp)
    80004e5c:	6906                	ld	s2,64(sp)
    80004e5e:	79e2                	ld	s3,56(sp)
    80004e60:	7a42                	ld	s4,48(sp)
    80004e62:	7aa2                	ld	s5,40(sp)
    80004e64:	7b02                	ld	s6,32(sp)
    80004e66:	6125                	addi	sp,sp,96
    80004e68:	8082                	ret
      if(n < target){
    80004e6a:	0009871b          	sext.w	a4,s3
    80004e6e:	01677a63          	bgeu	a4,s6,80004e82 <consoleread+0xee>
        cons.r--;
    80004e72:	0001c717          	auipc	a4,0x1c
    80004e76:	d4f72b23          	sw	a5,-682(a4) # 80020bc8 <cons+0x98>
    80004e7a:	6be2                	ld	s7,24(sp)
    80004e7c:	a031                	j	80004e88 <consoleread+0xf4>
    80004e7e:	ec5e                	sd	s7,24(sp)
    80004e80:	bfbd                	j	80004dfe <consoleread+0x6a>
    80004e82:	6be2                	ld	s7,24(sp)
    80004e84:	a011                	j	80004e88 <consoleread+0xf4>
    80004e86:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004e88:	0001c517          	auipc	a0,0x1c
    80004e8c:	ca850513          	addi	a0,a0,-856 # 80020b30 <cons>
    80004e90:	129000ef          	jal	800057b8 <release>
  return target - n;
    80004e94:	413b053b          	subw	a0,s6,s3
    80004e98:	bf7d                	j	80004e56 <consoleread+0xc2>
    80004e9a:	6be2                	ld	s7,24(sp)
    80004e9c:	b7f5                	j	80004e88 <consoleread+0xf4>

0000000080004e9e <consputc>:
{
    80004e9e:	1141                	addi	sp,sp,-16
    80004ea0:	e406                	sd	ra,8(sp)
    80004ea2:	e022                	sd	s0,0(sp)
    80004ea4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004ea6:	10000793          	li	a5,256
    80004eaa:	00f50863          	beq	a0,a5,80004eba <consputc+0x1c>
    uartputc_sync(c);
    80004eae:	604000ef          	jal	800054b2 <uartputc_sync>
}
    80004eb2:	60a2                	ld	ra,8(sp)
    80004eb4:	6402                	ld	s0,0(sp)
    80004eb6:	0141                	addi	sp,sp,16
    80004eb8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004eba:	4521                	li	a0,8
    80004ebc:	5f6000ef          	jal	800054b2 <uartputc_sync>
    80004ec0:	02000513          	li	a0,32
    80004ec4:	5ee000ef          	jal	800054b2 <uartputc_sync>
    80004ec8:	4521                	li	a0,8
    80004eca:	5e8000ef          	jal	800054b2 <uartputc_sync>
    80004ece:	b7d5                	j	80004eb2 <consputc+0x14>

0000000080004ed0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004ed0:	1101                	addi	sp,sp,-32
    80004ed2:	ec06                	sd	ra,24(sp)
    80004ed4:	e822                	sd	s0,16(sp)
    80004ed6:	e426                	sd	s1,8(sp)
    80004ed8:	1000                	addi	s0,sp,32
    80004eda:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004edc:	0001c517          	auipc	a0,0x1c
    80004ee0:	c5450513          	addi	a0,a0,-940 # 80020b30 <cons>
    80004ee4:	03d000ef          	jal	80005720 <acquire>

  switch(c){
    80004ee8:	47d5                	li	a5,21
    80004eea:	08f48f63          	beq	s1,a5,80004f88 <consoleintr+0xb8>
    80004eee:	0297c563          	blt	a5,s1,80004f18 <consoleintr+0x48>
    80004ef2:	47a1                	li	a5,8
    80004ef4:	0ef48463          	beq	s1,a5,80004fdc <consoleintr+0x10c>
    80004ef8:	47c1                	li	a5,16
    80004efa:	10f49563          	bne	s1,a5,80005004 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80004efe:	827fc0ef          	jal	80001724 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004f02:	0001c517          	auipc	a0,0x1c
    80004f06:	c2e50513          	addi	a0,a0,-978 # 80020b30 <cons>
    80004f0a:	0af000ef          	jal	800057b8 <release>
}
    80004f0e:	60e2                	ld	ra,24(sp)
    80004f10:	6442                	ld	s0,16(sp)
    80004f12:	64a2                	ld	s1,8(sp)
    80004f14:	6105                	addi	sp,sp,32
    80004f16:	8082                	ret
  switch(c){
    80004f18:	07f00793          	li	a5,127
    80004f1c:	0cf48063          	beq	s1,a5,80004fdc <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004f20:	0001c717          	auipc	a4,0x1c
    80004f24:	c1070713          	addi	a4,a4,-1008 # 80020b30 <cons>
    80004f28:	0a072783          	lw	a5,160(a4)
    80004f2c:	09872703          	lw	a4,152(a4)
    80004f30:	9f99                	subw	a5,a5,a4
    80004f32:	07f00713          	li	a4,127
    80004f36:	fcf766e3          	bltu	a4,a5,80004f02 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80004f3a:	47b5                	li	a5,13
    80004f3c:	0cf48763          	beq	s1,a5,8000500a <consoleintr+0x13a>
      consputc(c);
    80004f40:	8526                	mv	a0,s1
    80004f42:	f5dff0ef          	jal	80004e9e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004f46:	0001c797          	auipc	a5,0x1c
    80004f4a:	bea78793          	addi	a5,a5,-1046 # 80020b30 <cons>
    80004f4e:	0a07a683          	lw	a3,160(a5)
    80004f52:	0016871b          	addiw	a4,a3,1
    80004f56:	0007061b          	sext.w	a2,a4
    80004f5a:	0ae7a023          	sw	a4,160(a5)
    80004f5e:	07f6f693          	andi	a3,a3,127
    80004f62:	97b6                	add	a5,a5,a3
    80004f64:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004f68:	47a9                	li	a5,10
    80004f6a:	0cf48563          	beq	s1,a5,80005034 <consoleintr+0x164>
    80004f6e:	4791                	li	a5,4
    80004f70:	0cf48263          	beq	s1,a5,80005034 <consoleintr+0x164>
    80004f74:	0001c797          	auipc	a5,0x1c
    80004f78:	c547a783          	lw	a5,-940(a5) # 80020bc8 <cons+0x98>
    80004f7c:	9f1d                	subw	a4,a4,a5
    80004f7e:	08000793          	li	a5,128
    80004f82:	f8f710e3          	bne	a4,a5,80004f02 <consoleintr+0x32>
    80004f86:	a07d                	j	80005034 <consoleintr+0x164>
    80004f88:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80004f8a:	0001c717          	auipc	a4,0x1c
    80004f8e:	ba670713          	addi	a4,a4,-1114 # 80020b30 <cons>
    80004f92:	0a072783          	lw	a5,160(a4)
    80004f96:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004f9a:	0001c497          	auipc	s1,0x1c
    80004f9e:	b9648493          	addi	s1,s1,-1130 # 80020b30 <cons>
    while(cons.e != cons.w &&
    80004fa2:	4929                	li	s2,10
    80004fa4:	02f70863          	beq	a4,a5,80004fd4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fa8:	37fd                	addiw	a5,a5,-1
    80004faa:	07f7f713          	andi	a4,a5,127
    80004fae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80004fb0:	01874703          	lbu	a4,24(a4)
    80004fb4:	03270263          	beq	a4,s2,80004fd8 <consoleintr+0x108>
      cons.e--;
    80004fb8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80004fbc:	10000513          	li	a0,256
    80004fc0:	edfff0ef          	jal	80004e9e <consputc>
    while(cons.e != cons.w &&
    80004fc4:	0a04a783          	lw	a5,160(s1)
    80004fc8:	09c4a703          	lw	a4,156(s1)
    80004fcc:	fcf71ee3          	bne	a4,a5,80004fa8 <consoleintr+0xd8>
    80004fd0:	6902                	ld	s2,0(sp)
    80004fd2:	bf05                	j	80004f02 <consoleintr+0x32>
    80004fd4:	6902                	ld	s2,0(sp)
    80004fd6:	b735                	j	80004f02 <consoleintr+0x32>
    80004fd8:	6902                	ld	s2,0(sp)
    80004fda:	b725                	j	80004f02 <consoleintr+0x32>
    if(cons.e != cons.w){
    80004fdc:	0001c717          	auipc	a4,0x1c
    80004fe0:	b5470713          	addi	a4,a4,-1196 # 80020b30 <cons>
    80004fe4:	0a072783          	lw	a5,160(a4)
    80004fe8:	09c72703          	lw	a4,156(a4)
    80004fec:	f0f70be3          	beq	a4,a5,80004f02 <consoleintr+0x32>
      cons.e--;
    80004ff0:	37fd                	addiw	a5,a5,-1
    80004ff2:	0001c717          	auipc	a4,0x1c
    80004ff6:	bcf72f23          	sw	a5,-1058(a4) # 80020bd0 <cons+0xa0>
      consputc(BACKSPACE);
    80004ffa:	10000513          	li	a0,256
    80004ffe:	ea1ff0ef          	jal	80004e9e <consputc>
    80005002:	b701                	j	80004f02 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005004:	ee048fe3          	beqz	s1,80004f02 <consoleintr+0x32>
    80005008:	bf21                	j	80004f20 <consoleintr+0x50>
      consputc(c);
    8000500a:	4529                	li	a0,10
    8000500c:	e93ff0ef          	jal	80004e9e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005010:	0001c797          	auipc	a5,0x1c
    80005014:	b2078793          	addi	a5,a5,-1248 # 80020b30 <cons>
    80005018:	0a07a703          	lw	a4,160(a5)
    8000501c:	0017069b          	addiw	a3,a4,1
    80005020:	0006861b          	sext.w	a2,a3
    80005024:	0ad7a023          	sw	a3,160(a5)
    80005028:	07f77713          	andi	a4,a4,127
    8000502c:	97ba                	add	a5,a5,a4
    8000502e:	4729                	li	a4,10
    80005030:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005034:	0001c797          	auipc	a5,0x1c
    80005038:	b8c7ac23          	sw	a2,-1128(a5) # 80020bcc <cons+0x9c>
        wakeup(&cons.r);
    8000503c:	0001c517          	auipc	a0,0x1c
    80005040:	b8c50513          	addi	a0,a0,-1140 # 80020bc8 <cons+0x98>
    80005044:	b3cfc0ef          	jal	80001380 <wakeup>
    80005048:	bd6d                	j	80004f02 <consoleintr+0x32>

000000008000504a <consoleinit>:

void
consoleinit(void)
{
    8000504a:	1141                	addi	sp,sp,-16
    8000504c:	e406                	sd	ra,8(sp)
    8000504e:	e022                	sd	s0,0(sp)
    80005050:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005052:	00002597          	auipc	a1,0x2
    80005056:	6be58593          	addi	a1,a1,1726 # 80007710 <etext+0x710>
    8000505a:	0001c517          	auipc	a0,0x1c
    8000505e:	ad650513          	addi	a0,a0,-1322 # 80020b30 <cons>
    80005062:	63e000ef          	jal	800056a0 <initlock>

  uartinit();
    80005066:	3f4000ef          	jal	8000545a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000506a:	00013797          	auipc	a5,0x13
    8000506e:	92e78793          	addi	a5,a5,-1746 # 80017998 <devsw>
    80005072:	00000717          	auipc	a4,0x0
    80005076:	d2270713          	addi	a4,a4,-734 # 80004d94 <consoleread>
    8000507a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000507c:	00000717          	auipc	a4,0x0
    80005080:	cb270713          	addi	a4,a4,-846 # 80004d2e <consolewrite>
    80005084:	ef98                	sd	a4,24(a5)
}
    80005086:	60a2                	ld	ra,8(sp)
    80005088:	6402                	ld	s0,0(sp)
    8000508a:	0141                	addi	sp,sp,16
    8000508c:	8082                	ret

000000008000508e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000508e:	7179                	addi	sp,sp,-48
    80005090:	f406                	sd	ra,40(sp)
    80005092:	f022                	sd	s0,32(sp)
    80005094:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005096:	c219                	beqz	a2,8000509c <printint+0xe>
    80005098:	08054063          	bltz	a0,80005118 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000509c:	4881                	li	a7,0
    8000509e:	fd040693          	addi	a3,s0,-48

  i = 0;
    800050a2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800050a4:	00002617          	auipc	a2,0x2
    800050a8:	7c460613          	addi	a2,a2,1988 # 80007868 <digits>
    800050ac:	883e                	mv	a6,a5
    800050ae:	2785                	addiw	a5,a5,1
    800050b0:	02b57733          	remu	a4,a0,a1
    800050b4:	9732                	add	a4,a4,a2
    800050b6:	00074703          	lbu	a4,0(a4)
    800050ba:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800050be:	872a                	mv	a4,a0
    800050c0:	02b55533          	divu	a0,a0,a1
    800050c4:	0685                	addi	a3,a3,1
    800050c6:	feb773e3          	bgeu	a4,a1,800050ac <printint+0x1e>

  if(sign)
    800050ca:	00088a63          	beqz	a7,800050de <printint+0x50>
    buf[i++] = '-';
    800050ce:	1781                	addi	a5,a5,-32
    800050d0:	97a2                	add	a5,a5,s0
    800050d2:	02d00713          	li	a4,45
    800050d6:	fee78823          	sb	a4,-16(a5)
    800050da:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800050de:	02f05963          	blez	a5,80005110 <printint+0x82>
    800050e2:	ec26                	sd	s1,24(sp)
    800050e4:	e84a                	sd	s2,16(sp)
    800050e6:	fd040713          	addi	a4,s0,-48
    800050ea:	00f704b3          	add	s1,a4,a5
    800050ee:	fff70913          	addi	s2,a4,-1
    800050f2:	993e                	add	s2,s2,a5
    800050f4:	37fd                	addiw	a5,a5,-1
    800050f6:	1782                	slli	a5,a5,0x20
    800050f8:	9381                	srli	a5,a5,0x20
    800050fa:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800050fe:	fff4c503          	lbu	a0,-1(s1)
    80005102:	d9dff0ef          	jal	80004e9e <consputc>
  while(--i >= 0)
    80005106:	14fd                	addi	s1,s1,-1
    80005108:	ff249be3          	bne	s1,s2,800050fe <printint+0x70>
    8000510c:	64e2                	ld	s1,24(sp)
    8000510e:	6942                	ld	s2,16(sp)
}
    80005110:	70a2                	ld	ra,40(sp)
    80005112:	7402                	ld	s0,32(sp)
    80005114:	6145                	addi	sp,sp,48
    80005116:	8082                	ret
    x = -xx;
    80005118:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000511c:	4885                	li	a7,1
    x = -xx;
    8000511e:	b741                	j	8000509e <printint+0x10>

0000000080005120 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005120:	7155                	addi	sp,sp,-208
    80005122:	e506                	sd	ra,136(sp)
    80005124:	e122                	sd	s0,128(sp)
    80005126:	f0d2                	sd	s4,96(sp)
    80005128:	0900                	addi	s0,sp,144
    8000512a:	8a2a                	mv	s4,a0
    8000512c:	e40c                	sd	a1,8(s0)
    8000512e:	e810                	sd	a2,16(s0)
    80005130:	ec14                	sd	a3,24(s0)
    80005132:	f018                	sd	a4,32(s0)
    80005134:	f41c                	sd	a5,40(s0)
    80005136:	03043823          	sd	a6,48(s0)
    8000513a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000513e:	0001c797          	auipc	a5,0x1c
    80005142:	ab27a783          	lw	a5,-1358(a5) # 80020bf0 <pr+0x18>
    80005146:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000514a:	e3a1                	bnez	a5,8000518a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000514c:	00840793          	addi	a5,s0,8
    80005150:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005154:	00054503          	lbu	a0,0(a0)
    80005158:	26050763          	beqz	a0,800053c6 <printf+0x2a6>
    8000515c:	fca6                	sd	s1,120(sp)
    8000515e:	f8ca                	sd	s2,112(sp)
    80005160:	f4ce                	sd	s3,104(sp)
    80005162:	ecd6                	sd	s5,88(sp)
    80005164:	e8da                	sd	s6,80(sp)
    80005166:	e0e2                	sd	s8,64(sp)
    80005168:	fc66                	sd	s9,56(sp)
    8000516a:	f86a                	sd	s10,48(sp)
    8000516c:	f46e                	sd	s11,40(sp)
    8000516e:	4981                	li	s3,0
    if(cx != '%'){
    80005170:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005174:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005178:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000517c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005180:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005184:	07000d93          	li	s11,112
    80005188:	a815                	j	800051bc <printf+0x9c>
    acquire(&pr.lock);
    8000518a:	0001c517          	auipc	a0,0x1c
    8000518e:	a4e50513          	addi	a0,a0,-1458 # 80020bd8 <pr>
    80005192:	58e000ef          	jal	80005720 <acquire>
  va_start(ap, fmt);
    80005196:	00840793          	addi	a5,s0,8
    8000519a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000519e:	000a4503          	lbu	a0,0(s4)
    800051a2:	fd4d                	bnez	a0,8000515c <printf+0x3c>
    800051a4:	a481                	j	800053e4 <printf+0x2c4>
      consputc(cx);
    800051a6:	cf9ff0ef          	jal	80004e9e <consputc>
      continue;
    800051aa:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051ac:	0014899b          	addiw	s3,s1,1
    800051b0:	013a07b3          	add	a5,s4,s3
    800051b4:	0007c503          	lbu	a0,0(a5)
    800051b8:	1e050b63          	beqz	a0,800053ae <printf+0x28e>
    if(cx != '%'){
    800051bc:	ff5515e3          	bne	a0,s5,800051a6 <printf+0x86>
    i++;
    800051c0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800051c4:	009a07b3          	add	a5,s4,s1
    800051c8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800051cc:	1e090163          	beqz	s2,800053ae <printf+0x28e>
    800051d0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800051d4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800051d6:	c789                	beqz	a5,800051e0 <printf+0xc0>
    800051d8:	009a0733          	add	a4,s4,s1
    800051dc:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800051e0:	03690763          	beq	s2,s6,8000520e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800051e4:	05890163          	beq	s2,s8,80005226 <printf+0x106>
    } else if(c0 == 'u'){
    800051e8:	0d990b63          	beq	s2,s9,800052be <printf+0x19e>
    } else if(c0 == 'x'){
    800051ec:	13a90163          	beq	s2,s10,8000530e <printf+0x1ee>
    } else if(c0 == 'p'){
    800051f0:	13b90b63          	beq	s2,s11,80005326 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800051f4:	07300793          	li	a5,115
    800051f8:	16f90a63          	beq	s2,a5,8000536c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800051fc:	1b590463          	beq	s2,s5,800053a4 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005200:	8556                	mv	a0,s5
    80005202:	c9dff0ef          	jal	80004e9e <consputc>
      consputc(c0);
    80005206:	854a                	mv	a0,s2
    80005208:	c97ff0ef          	jal	80004e9e <consputc>
    8000520c:	b745                	j	800051ac <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000520e:	f8843783          	ld	a5,-120(s0)
    80005212:	00878713          	addi	a4,a5,8
    80005216:	f8e43423          	sd	a4,-120(s0)
    8000521a:	4605                	li	a2,1
    8000521c:	45a9                	li	a1,10
    8000521e:	4388                	lw	a0,0(a5)
    80005220:	e6fff0ef          	jal	8000508e <printint>
    80005224:	b761                	j	800051ac <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005226:	03678663          	beq	a5,s6,80005252 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000522a:	05878263          	beq	a5,s8,8000526e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000522e:	0b978463          	beq	a5,s9,800052d6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005232:	fda797e3          	bne	a5,s10,80005200 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005236:	f8843783          	ld	a5,-120(s0)
    8000523a:	00878713          	addi	a4,a5,8
    8000523e:	f8e43423          	sd	a4,-120(s0)
    80005242:	4601                	li	a2,0
    80005244:	45c1                	li	a1,16
    80005246:	6388                	ld	a0,0(a5)
    80005248:	e47ff0ef          	jal	8000508e <printint>
      i += 1;
    8000524c:	0029849b          	addiw	s1,s3,2
    80005250:	bfb1                	j	800051ac <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005252:	f8843783          	ld	a5,-120(s0)
    80005256:	00878713          	addi	a4,a5,8
    8000525a:	f8e43423          	sd	a4,-120(s0)
    8000525e:	4605                	li	a2,1
    80005260:	45a9                	li	a1,10
    80005262:	6388                	ld	a0,0(a5)
    80005264:	e2bff0ef          	jal	8000508e <printint>
      i += 1;
    80005268:	0029849b          	addiw	s1,s3,2
    8000526c:	b781                	j	800051ac <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000526e:	06400793          	li	a5,100
    80005272:	02f68863          	beq	a3,a5,800052a2 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005276:	07500793          	li	a5,117
    8000527a:	06f68c63          	beq	a3,a5,800052f2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000527e:	07800793          	li	a5,120
    80005282:	f6f69fe3          	bne	a3,a5,80005200 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005286:	f8843783          	ld	a5,-120(s0)
    8000528a:	00878713          	addi	a4,a5,8
    8000528e:	f8e43423          	sd	a4,-120(s0)
    80005292:	4601                	li	a2,0
    80005294:	45c1                	li	a1,16
    80005296:	6388                	ld	a0,0(a5)
    80005298:	df7ff0ef          	jal	8000508e <printint>
      i += 2;
    8000529c:	0039849b          	addiw	s1,s3,3
    800052a0:	b731                	j	800051ac <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800052a2:	f8843783          	ld	a5,-120(s0)
    800052a6:	00878713          	addi	a4,a5,8
    800052aa:	f8e43423          	sd	a4,-120(s0)
    800052ae:	4605                	li	a2,1
    800052b0:	45a9                	li	a1,10
    800052b2:	6388                	ld	a0,0(a5)
    800052b4:	ddbff0ef          	jal	8000508e <printint>
      i += 2;
    800052b8:	0039849b          	addiw	s1,s3,3
    800052bc:	bdc5                	j	800051ac <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800052be:	f8843783          	ld	a5,-120(s0)
    800052c2:	00878713          	addi	a4,a5,8
    800052c6:	f8e43423          	sd	a4,-120(s0)
    800052ca:	4601                	li	a2,0
    800052cc:	45a9                	li	a1,10
    800052ce:	4388                	lw	a0,0(a5)
    800052d0:	dbfff0ef          	jal	8000508e <printint>
    800052d4:	bde1                	j	800051ac <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052d6:	f8843783          	ld	a5,-120(s0)
    800052da:	00878713          	addi	a4,a5,8
    800052de:	f8e43423          	sd	a4,-120(s0)
    800052e2:	4601                	li	a2,0
    800052e4:	45a9                	li	a1,10
    800052e6:	6388                	ld	a0,0(a5)
    800052e8:	da7ff0ef          	jal	8000508e <printint>
      i += 1;
    800052ec:	0029849b          	addiw	s1,s3,2
    800052f0:	bd75                	j	800051ac <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052f2:	f8843783          	ld	a5,-120(s0)
    800052f6:	00878713          	addi	a4,a5,8
    800052fa:	f8e43423          	sd	a4,-120(s0)
    800052fe:	4601                	li	a2,0
    80005300:	45a9                	li	a1,10
    80005302:	6388                	ld	a0,0(a5)
    80005304:	d8bff0ef          	jal	8000508e <printint>
      i += 2;
    80005308:	0039849b          	addiw	s1,s3,3
    8000530c:	b545                	j	800051ac <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000530e:	f8843783          	ld	a5,-120(s0)
    80005312:	00878713          	addi	a4,a5,8
    80005316:	f8e43423          	sd	a4,-120(s0)
    8000531a:	4601                	li	a2,0
    8000531c:	45c1                	li	a1,16
    8000531e:	4388                	lw	a0,0(a5)
    80005320:	d6fff0ef          	jal	8000508e <printint>
    80005324:	b561                	j	800051ac <printf+0x8c>
    80005326:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005328:	f8843783          	ld	a5,-120(s0)
    8000532c:	00878713          	addi	a4,a5,8
    80005330:	f8e43423          	sd	a4,-120(s0)
    80005334:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005338:	03000513          	li	a0,48
    8000533c:	b63ff0ef          	jal	80004e9e <consputc>
  consputc('x');
    80005340:	07800513          	li	a0,120
    80005344:	b5bff0ef          	jal	80004e9e <consputc>
    80005348:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000534a:	00002b97          	auipc	s7,0x2
    8000534e:	51eb8b93          	addi	s7,s7,1310 # 80007868 <digits>
    80005352:	03c9d793          	srli	a5,s3,0x3c
    80005356:	97de                	add	a5,a5,s7
    80005358:	0007c503          	lbu	a0,0(a5)
    8000535c:	b43ff0ef          	jal	80004e9e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005360:	0992                	slli	s3,s3,0x4
    80005362:	397d                	addiw	s2,s2,-1
    80005364:	fe0917e3          	bnez	s2,80005352 <printf+0x232>
    80005368:	6ba6                	ld	s7,72(sp)
    8000536a:	b589                	j	800051ac <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000536c:	f8843783          	ld	a5,-120(s0)
    80005370:	00878713          	addi	a4,a5,8
    80005374:	f8e43423          	sd	a4,-120(s0)
    80005378:	0007b903          	ld	s2,0(a5)
    8000537c:	00090d63          	beqz	s2,80005396 <printf+0x276>
      for(; *s; s++)
    80005380:	00094503          	lbu	a0,0(s2)
    80005384:	e20504e3          	beqz	a0,800051ac <printf+0x8c>
        consputc(*s);
    80005388:	b17ff0ef          	jal	80004e9e <consputc>
      for(; *s; s++)
    8000538c:	0905                	addi	s2,s2,1
    8000538e:	00094503          	lbu	a0,0(s2)
    80005392:	f97d                	bnez	a0,80005388 <printf+0x268>
    80005394:	bd21                	j	800051ac <printf+0x8c>
        s = "(null)";
    80005396:	00002917          	auipc	s2,0x2
    8000539a:	38290913          	addi	s2,s2,898 # 80007718 <etext+0x718>
      for(; *s; s++)
    8000539e:	02800513          	li	a0,40
    800053a2:	b7dd                	j	80005388 <printf+0x268>
      consputc('%');
    800053a4:	02500513          	li	a0,37
    800053a8:	af7ff0ef          	jal	80004e9e <consputc>
    800053ac:	b501                	j	800051ac <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800053ae:	f7843783          	ld	a5,-136(s0)
    800053b2:	e385                	bnez	a5,800053d2 <printf+0x2b2>
    800053b4:	74e6                	ld	s1,120(sp)
    800053b6:	7946                	ld	s2,112(sp)
    800053b8:	79a6                	ld	s3,104(sp)
    800053ba:	6ae6                	ld	s5,88(sp)
    800053bc:	6b46                	ld	s6,80(sp)
    800053be:	6c06                	ld	s8,64(sp)
    800053c0:	7ce2                	ld	s9,56(sp)
    800053c2:	7d42                	ld	s10,48(sp)
    800053c4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800053c6:	4501                	li	a0,0
    800053c8:	60aa                	ld	ra,136(sp)
    800053ca:	640a                	ld	s0,128(sp)
    800053cc:	7a06                	ld	s4,96(sp)
    800053ce:	6169                	addi	sp,sp,208
    800053d0:	8082                	ret
    800053d2:	74e6                	ld	s1,120(sp)
    800053d4:	7946                	ld	s2,112(sp)
    800053d6:	79a6                	ld	s3,104(sp)
    800053d8:	6ae6                	ld	s5,88(sp)
    800053da:	6b46                	ld	s6,80(sp)
    800053dc:	6c06                	ld	s8,64(sp)
    800053de:	7ce2                	ld	s9,56(sp)
    800053e0:	7d42                	ld	s10,48(sp)
    800053e2:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800053e4:	0001b517          	auipc	a0,0x1b
    800053e8:	7f450513          	addi	a0,a0,2036 # 80020bd8 <pr>
    800053ec:	3cc000ef          	jal	800057b8 <release>
    800053f0:	bfd9                	j	800053c6 <printf+0x2a6>

00000000800053f2 <panic>:

void
panic(char *s)
{
    800053f2:	1101                	addi	sp,sp,-32
    800053f4:	ec06                	sd	ra,24(sp)
    800053f6:	e822                	sd	s0,16(sp)
    800053f8:	e426                	sd	s1,8(sp)
    800053fa:	1000                	addi	s0,sp,32
    800053fc:	84aa                	mv	s1,a0
  pr.locking = 0;
    800053fe:	0001b797          	auipc	a5,0x1b
    80005402:	7e07a923          	sw	zero,2034(a5) # 80020bf0 <pr+0x18>
  printf("panic: ");
    80005406:	00002517          	auipc	a0,0x2
    8000540a:	31a50513          	addi	a0,a0,794 # 80007720 <etext+0x720>
    8000540e:	d13ff0ef          	jal	80005120 <printf>
  printf("%s\n", s);
    80005412:	85a6                	mv	a1,s1
    80005414:	00002517          	auipc	a0,0x2
    80005418:	31450513          	addi	a0,a0,788 # 80007728 <etext+0x728>
    8000541c:	d05ff0ef          	jal	80005120 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005420:	4785                	li	a5,1
    80005422:	00002717          	auipc	a4,0x2
    80005426:	4cf72523          	sw	a5,1226(a4) # 800078ec <panicked>
  for(;;)
    8000542a:	a001                	j	8000542a <panic+0x38>

000000008000542c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000542c:	1101                	addi	sp,sp,-32
    8000542e:	ec06                	sd	ra,24(sp)
    80005430:	e822                	sd	s0,16(sp)
    80005432:	e426                	sd	s1,8(sp)
    80005434:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005436:	0001b497          	auipc	s1,0x1b
    8000543a:	7a248493          	addi	s1,s1,1954 # 80020bd8 <pr>
    8000543e:	00002597          	auipc	a1,0x2
    80005442:	2f258593          	addi	a1,a1,754 # 80007730 <etext+0x730>
    80005446:	8526                	mv	a0,s1
    80005448:	258000ef          	jal	800056a0 <initlock>
  pr.locking = 1;
    8000544c:	4785                	li	a5,1
    8000544e:	cc9c                	sw	a5,24(s1)
}
    80005450:	60e2                	ld	ra,24(sp)
    80005452:	6442                	ld	s0,16(sp)
    80005454:	64a2                	ld	s1,8(sp)
    80005456:	6105                	addi	sp,sp,32
    80005458:	8082                	ret

000000008000545a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000545a:	1141                	addi	sp,sp,-16
    8000545c:	e406                	sd	ra,8(sp)
    8000545e:	e022                	sd	s0,0(sp)
    80005460:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005462:	100007b7          	lui	a5,0x10000
    80005466:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000546a:	10000737          	lui	a4,0x10000
    8000546e:	f8000693          	li	a3,-128
    80005472:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005476:	468d                	li	a3,3
    80005478:	10000637          	lui	a2,0x10000
    8000547c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005480:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005484:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005488:	10000737          	lui	a4,0x10000
    8000548c:	461d                	li	a2,7
    8000548e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005492:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005496:	00002597          	auipc	a1,0x2
    8000549a:	2a258593          	addi	a1,a1,674 # 80007738 <etext+0x738>
    8000549e:	0001b517          	auipc	a0,0x1b
    800054a2:	75a50513          	addi	a0,a0,1882 # 80020bf8 <uart_tx_lock>
    800054a6:	1fa000ef          	jal	800056a0 <initlock>
}
    800054aa:	60a2                	ld	ra,8(sp)
    800054ac:	6402                	ld	s0,0(sp)
    800054ae:	0141                	addi	sp,sp,16
    800054b0:	8082                	ret

00000000800054b2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800054b2:	1101                	addi	sp,sp,-32
    800054b4:	ec06                	sd	ra,24(sp)
    800054b6:	e822                	sd	s0,16(sp)
    800054b8:	e426                	sd	s1,8(sp)
    800054ba:	1000                	addi	s0,sp,32
    800054bc:	84aa                	mv	s1,a0
  push_off();
    800054be:	222000ef          	jal	800056e0 <push_off>

  if(panicked){
    800054c2:	00002797          	auipc	a5,0x2
    800054c6:	42a7a783          	lw	a5,1066(a5) # 800078ec <panicked>
    800054ca:	e795                	bnez	a5,800054f6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800054cc:	10000737          	lui	a4,0x10000
    800054d0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800054d2:	00074783          	lbu	a5,0(a4)
    800054d6:	0207f793          	andi	a5,a5,32
    800054da:	dfe5                	beqz	a5,800054d2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800054dc:	0ff4f513          	zext.b	a0,s1
    800054e0:	100007b7          	lui	a5,0x10000
    800054e4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800054e8:	27c000ef          	jal	80005764 <pop_off>
}
    800054ec:	60e2                	ld	ra,24(sp)
    800054ee:	6442                	ld	s0,16(sp)
    800054f0:	64a2                	ld	s1,8(sp)
    800054f2:	6105                	addi	sp,sp,32
    800054f4:	8082                	ret
    for(;;)
    800054f6:	a001                	j	800054f6 <uartputc_sync+0x44>

00000000800054f8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800054f8:	00002797          	auipc	a5,0x2
    800054fc:	3f87b783          	ld	a5,1016(a5) # 800078f0 <uart_tx_r>
    80005500:	00002717          	auipc	a4,0x2
    80005504:	3f873703          	ld	a4,1016(a4) # 800078f8 <uart_tx_w>
    80005508:	08f70263          	beq	a4,a5,8000558c <uartstart+0x94>
{
    8000550c:	7139                	addi	sp,sp,-64
    8000550e:	fc06                	sd	ra,56(sp)
    80005510:	f822                	sd	s0,48(sp)
    80005512:	f426                	sd	s1,40(sp)
    80005514:	f04a                	sd	s2,32(sp)
    80005516:	ec4e                	sd	s3,24(sp)
    80005518:	e852                	sd	s4,16(sp)
    8000551a:	e456                	sd	s5,8(sp)
    8000551c:	e05a                	sd	s6,0(sp)
    8000551e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005520:	10000937          	lui	s2,0x10000
    80005524:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005526:	0001ba97          	auipc	s5,0x1b
    8000552a:	6d2a8a93          	addi	s5,s5,1746 # 80020bf8 <uart_tx_lock>
    uart_tx_r += 1;
    8000552e:	00002497          	auipc	s1,0x2
    80005532:	3c248493          	addi	s1,s1,962 # 800078f0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005536:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000553a:	00002997          	auipc	s3,0x2
    8000553e:	3be98993          	addi	s3,s3,958 # 800078f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005542:	00094703          	lbu	a4,0(s2)
    80005546:	02077713          	andi	a4,a4,32
    8000554a:	c71d                	beqz	a4,80005578 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000554c:	01f7f713          	andi	a4,a5,31
    80005550:	9756                	add	a4,a4,s5
    80005552:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005556:	0785                	addi	a5,a5,1
    80005558:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000555a:	8526                	mv	a0,s1
    8000555c:	e25fb0ef          	jal	80001380 <wakeup>
    WriteReg(THR, c);
    80005560:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005564:	609c                	ld	a5,0(s1)
    80005566:	0009b703          	ld	a4,0(s3)
    8000556a:	fcf71ce3          	bne	a4,a5,80005542 <uartstart+0x4a>
      ReadReg(ISR);
    8000556e:	100007b7          	lui	a5,0x10000
    80005572:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005574:	0007c783          	lbu	a5,0(a5)
  }
}
    80005578:	70e2                	ld	ra,56(sp)
    8000557a:	7442                	ld	s0,48(sp)
    8000557c:	74a2                	ld	s1,40(sp)
    8000557e:	7902                	ld	s2,32(sp)
    80005580:	69e2                	ld	s3,24(sp)
    80005582:	6a42                	ld	s4,16(sp)
    80005584:	6aa2                	ld	s5,8(sp)
    80005586:	6b02                	ld	s6,0(sp)
    80005588:	6121                	addi	sp,sp,64
    8000558a:	8082                	ret
      ReadReg(ISR);
    8000558c:	100007b7          	lui	a5,0x10000
    80005590:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005592:	0007c783          	lbu	a5,0(a5)
      return;
    80005596:	8082                	ret

0000000080005598 <uartputc>:
{
    80005598:	7179                	addi	sp,sp,-48
    8000559a:	f406                	sd	ra,40(sp)
    8000559c:	f022                	sd	s0,32(sp)
    8000559e:	ec26                	sd	s1,24(sp)
    800055a0:	e84a                	sd	s2,16(sp)
    800055a2:	e44e                	sd	s3,8(sp)
    800055a4:	e052                	sd	s4,0(sp)
    800055a6:	1800                	addi	s0,sp,48
    800055a8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800055aa:	0001b517          	auipc	a0,0x1b
    800055ae:	64e50513          	addi	a0,a0,1614 # 80020bf8 <uart_tx_lock>
    800055b2:	16e000ef          	jal	80005720 <acquire>
  if(panicked){
    800055b6:	00002797          	auipc	a5,0x2
    800055ba:	3367a783          	lw	a5,822(a5) # 800078ec <panicked>
    800055be:	efbd                	bnez	a5,8000563c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055c0:	00002717          	auipc	a4,0x2
    800055c4:	33873703          	ld	a4,824(a4) # 800078f8 <uart_tx_w>
    800055c8:	00002797          	auipc	a5,0x2
    800055cc:	3287b783          	ld	a5,808(a5) # 800078f0 <uart_tx_r>
    800055d0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800055d4:	0001b997          	auipc	s3,0x1b
    800055d8:	62498993          	addi	s3,s3,1572 # 80020bf8 <uart_tx_lock>
    800055dc:	00002497          	auipc	s1,0x2
    800055e0:	31448493          	addi	s1,s1,788 # 800078f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055e4:	00002917          	auipc	s2,0x2
    800055e8:	31490913          	addi	s2,s2,788 # 800078f8 <uart_tx_w>
    800055ec:	00e79d63          	bne	a5,a4,80005606 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800055f0:	85ce                	mv	a1,s3
    800055f2:	8526                	mv	a0,s1
    800055f4:	d41fb0ef          	jal	80001334 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055f8:	00093703          	ld	a4,0(s2)
    800055fc:	609c                	ld	a5,0(s1)
    800055fe:	02078793          	addi	a5,a5,32
    80005602:	fee787e3          	beq	a5,a4,800055f0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005606:	0001b497          	auipc	s1,0x1b
    8000560a:	5f248493          	addi	s1,s1,1522 # 80020bf8 <uart_tx_lock>
    8000560e:	01f77793          	andi	a5,a4,31
    80005612:	97a6                	add	a5,a5,s1
    80005614:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005618:	0705                	addi	a4,a4,1
    8000561a:	00002797          	auipc	a5,0x2
    8000561e:	2ce7bf23          	sd	a4,734(a5) # 800078f8 <uart_tx_w>
  uartstart();
    80005622:	ed7ff0ef          	jal	800054f8 <uartstart>
  release(&uart_tx_lock);
    80005626:	8526                	mv	a0,s1
    80005628:	190000ef          	jal	800057b8 <release>
}
    8000562c:	70a2                	ld	ra,40(sp)
    8000562e:	7402                	ld	s0,32(sp)
    80005630:	64e2                	ld	s1,24(sp)
    80005632:	6942                	ld	s2,16(sp)
    80005634:	69a2                	ld	s3,8(sp)
    80005636:	6a02                	ld	s4,0(sp)
    80005638:	6145                	addi	sp,sp,48
    8000563a:	8082                	ret
    for(;;)
    8000563c:	a001                	j	8000563c <uartputc+0xa4>

000000008000563e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000563e:	1141                	addi	sp,sp,-16
    80005640:	e422                	sd	s0,8(sp)
    80005642:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005644:	100007b7          	lui	a5,0x10000
    80005648:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000564a:	0007c783          	lbu	a5,0(a5)
    8000564e:	8b85                	andi	a5,a5,1
    80005650:	cb81                	beqz	a5,80005660 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005652:	100007b7          	lui	a5,0x10000
    80005656:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000565a:	6422                	ld	s0,8(sp)
    8000565c:	0141                	addi	sp,sp,16
    8000565e:	8082                	ret
    return -1;
    80005660:	557d                	li	a0,-1
    80005662:	bfe5                	j	8000565a <uartgetc+0x1c>

0000000080005664 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005664:	1101                	addi	sp,sp,-32
    80005666:	ec06                	sd	ra,24(sp)
    80005668:	e822                	sd	s0,16(sp)
    8000566a:	e426                	sd	s1,8(sp)
    8000566c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000566e:	54fd                	li	s1,-1
    80005670:	a019                	j	80005676 <uartintr+0x12>
      break;
    consoleintr(c);
    80005672:	85fff0ef          	jal	80004ed0 <consoleintr>
    int c = uartgetc();
    80005676:	fc9ff0ef          	jal	8000563e <uartgetc>
    if(c == -1)
    8000567a:	fe951ce3          	bne	a0,s1,80005672 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000567e:	0001b497          	auipc	s1,0x1b
    80005682:	57a48493          	addi	s1,s1,1402 # 80020bf8 <uart_tx_lock>
    80005686:	8526                	mv	a0,s1
    80005688:	098000ef          	jal	80005720 <acquire>
  uartstart();
    8000568c:	e6dff0ef          	jal	800054f8 <uartstart>
  release(&uart_tx_lock);
    80005690:	8526                	mv	a0,s1
    80005692:	126000ef          	jal	800057b8 <release>
}
    80005696:	60e2                	ld	ra,24(sp)
    80005698:	6442                	ld	s0,16(sp)
    8000569a:	64a2                	ld	s1,8(sp)
    8000569c:	6105                	addi	sp,sp,32
    8000569e:	8082                	ret

00000000800056a0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800056a0:	1141                	addi	sp,sp,-16
    800056a2:	e422                	sd	s0,8(sp)
    800056a4:	0800                	addi	s0,sp,16
  lk->name = name;
    800056a6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800056a8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800056ac:	00053823          	sd	zero,16(a0)
}
    800056b0:	6422                	ld	s0,8(sp)
    800056b2:	0141                	addi	sp,sp,16
    800056b4:	8082                	ret

00000000800056b6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800056b6:	411c                	lw	a5,0(a0)
    800056b8:	e399                	bnez	a5,800056be <holding+0x8>
    800056ba:	4501                	li	a0,0
  return r;
}
    800056bc:	8082                	ret
{
    800056be:	1101                	addi	sp,sp,-32
    800056c0:	ec06                	sd	ra,24(sp)
    800056c2:	e822                	sd	s0,16(sp)
    800056c4:	e426                	sd	s1,8(sp)
    800056c6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800056c8:	6904                	ld	s1,16(a0)
    800056ca:	e80fb0ef          	jal	80000d4a <mycpu>
    800056ce:	40a48533          	sub	a0,s1,a0
    800056d2:	00153513          	seqz	a0,a0
}
    800056d6:	60e2                	ld	ra,24(sp)
    800056d8:	6442                	ld	s0,16(sp)
    800056da:	64a2                	ld	s1,8(sp)
    800056dc:	6105                	addi	sp,sp,32
    800056de:	8082                	ret

00000000800056e0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800056e0:	1101                	addi	sp,sp,-32
    800056e2:	ec06                	sd	ra,24(sp)
    800056e4:	e822                	sd	s0,16(sp)
    800056e6:	e426                	sd	s1,8(sp)
    800056e8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800056ea:	100024f3          	csrr	s1,sstatus
    800056ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800056f2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800056f4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800056f8:	e52fb0ef          	jal	80000d4a <mycpu>
    800056fc:	5d3c                	lw	a5,120(a0)
    800056fe:	cb99                	beqz	a5,80005714 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005700:	e4afb0ef          	jal	80000d4a <mycpu>
    80005704:	5d3c                	lw	a5,120(a0)
    80005706:	2785                	addiw	a5,a5,1
    80005708:	dd3c                	sw	a5,120(a0)
}
    8000570a:	60e2                	ld	ra,24(sp)
    8000570c:	6442                	ld	s0,16(sp)
    8000570e:	64a2                	ld	s1,8(sp)
    80005710:	6105                	addi	sp,sp,32
    80005712:	8082                	ret
    mycpu()->intena = old;
    80005714:	e36fb0ef          	jal	80000d4a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005718:	8085                	srli	s1,s1,0x1
    8000571a:	8885                	andi	s1,s1,1
    8000571c:	dd64                	sw	s1,124(a0)
    8000571e:	b7cd                	j	80005700 <push_off+0x20>

0000000080005720 <acquire>:
{
    80005720:	1101                	addi	sp,sp,-32
    80005722:	ec06                	sd	ra,24(sp)
    80005724:	e822                	sd	s0,16(sp)
    80005726:	e426                	sd	s1,8(sp)
    80005728:	1000                	addi	s0,sp,32
    8000572a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000572c:	fb5ff0ef          	jal	800056e0 <push_off>
  if(holding(lk))
    80005730:	8526                	mv	a0,s1
    80005732:	f85ff0ef          	jal	800056b6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005736:	4705                	li	a4,1
  if(holding(lk))
    80005738:	e105                	bnez	a0,80005758 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000573a:	87ba                	mv	a5,a4
    8000573c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005740:	2781                	sext.w	a5,a5
    80005742:	ffe5                	bnez	a5,8000573a <acquire+0x1a>
  __sync_synchronize();
    80005744:	0ff0000f          	fence
  lk->cpu = mycpu();
    80005748:	e02fb0ef          	jal	80000d4a <mycpu>
    8000574c:	e888                	sd	a0,16(s1)
}
    8000574e:	60e2                	ld	ra,24(sp)
    80005750:	6442                	ld	s0,16(sp)
    80005752:	64a2                	ld	s1,8(sp)
    80005754:	6105                	addi	sp,sp,32
    80005756:	8082                	ret
    panic("acquire");
    80005758:	00002517          	auipc	a0,0x2
    8000575c:	fe850513          	addi	a0,a0,-24 # 80007740 <etext+0x740>
    80005760:	c93ff0ef          	jal	800053f2 <panic>

0000000080005764 <pop_off>:

void
pop_off(void)
{
    80005764:	1141                	addi	sp,sp,-16
    80005766:	e406                	sd	ra,8(sp)
    80005768:	e022                	sd	s0,0(sp)
    8000576a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000576c:	ddefb0ef          	jal	80000d4a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005770:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005774:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005776:	e78d                	bnez	a5,800057a0 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005778:	5d3c                	lw	a5,120(a0)
    8000577a:	02f05963          	blez	a5,800057ac <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000577e:	37fd                	addiw	a5,a5,-1
    80005780:	0007871b          	sext.w	a4,a5
    80005784:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005786:	eb09                	bnez	a4,80005798 <pop_off+0x34>
    80005788:	5d7c                	lw	a5,124(a0)
    8000578a:	c799                	beqz	a5,80005798 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000578c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005790:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005794:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005798:	60a2                	ld	ra,8(sp)
    8000579a:	6402                	ld	s0,0(sp)
    8000579c:	0141                	addi	sp,sp,16
    8000579e:	8082                	ret
    panic("pop_off - interruptible");
    800057a0:	00002517          	auipc	a0,0x2
    800057a4:	fa850513          	addi	a0,a0,-88 # 80007748 <etext+0x748>
    800057a8:	c4bff0ef          	jal	800053f2 <panic>
    panic("pop_off");
    800057ac:	00002517          	auipc	a0,0x2
    800057b0:	fb450513          	addi	a0,a0,-76 # 80007760 <etext+0x760>
    800057b4:	c3fff0ef          	jal	800053f2 <panic>

00000000800057b8 <release>:
{
    800057b8:	1101                	addi	sp,sp,-32
    800057ba:	ec06                	sd	ra,24(sp)
    800057bc:	e822                	sd	s0,16(sp)
    800057be:	e426                	sd	s1,8(sp)
    800057c0:	1000                	addi	s0,sp,32
    800057c2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800057c4:	ef3ff0ef          	jal	800056b6 <holding>
    800057c8:	c105                	beqz	a0,800057e8 <release+0x30>
  lk->cpu = 0;
    800057ca:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800057ce:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800057d2:	0f50000f          	fence	iorw,ow
    800057d6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800057da:	f8bff0ef          	jal	80005764 <pop_off>
}
    800057de:	60e2                	ld	ra,24(sp)
    800057e0:	6442                	ld	s0,16(sp)
    800057e2:	64a2                	ld	s1,8(sp)
    800057e4:	6105                	addi	sp,sp,32
    800057e6:	8082                	ret
    panic("release");
    800057e8:	00002517          	auipc	a0,0x2
    800057ec:	f8050513          	addi	a0,a0,-128 # 80007768 <etext+0x768>
    800057f0:	c03ff0ef          	jal	800053f2 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
