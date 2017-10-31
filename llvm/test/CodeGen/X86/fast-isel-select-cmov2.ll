; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin10                               | FileCheck %s --check-prefix=CHECK --check-prefix=NOAVX --check-prefix=SDAG
; RUN: llc < %s -mtriple=x86_64-apple-darwin10 -fast-isel -fast-isel-abort=1 | FileCheck %s --check-prefix=CHECK --check-prefix=NOAVX --check-prefix=FAST
; RUN: llc < %s -mtriple=x86_64-apple-darwin10 -fast-isel -fast-isel-abort=1 -mattr=avx | FileCheck %s --check-prefix=CHECK --check-prefix=FAST_AVX
; RUN: llc < %s -mtriple=x86_64-apple-darwin10 -fast-isel -fast-isel-abort=1 -mattr=avx512f | FileCheck %s --check-prefix=CHECK --check-prefix=FAST_AVX

; Test all the cmp predicates that can feed an integer conditional move.

define i64 @select_fcmp_false_cmov(double %a, double %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_fcmp_false_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %1 = fcmp false double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_oeq_cmov(double %a, double %b, i64 %c, i64 %d) {
; SDAG-LABEL: select_fcmp_oeq_cmov:
; SDAG:       ## BB#0:
; SDAG-NEXT:    ucomisd %xmm1, %xmm0
; SDAG-NEXT:    cmovneq %rsi, %rdi
; SDAG-NEXT:    cmovpq %rsi, %rdi
; SDAG-NEXT:    movq %rdi, %rax
; SDAG-NEXT:    retq
;
; FAST-LABEL: select_fcmp_oeq_cmov:
; FAST:       ## BB#0:
; FAST-NEXT:    ucomisd %xmm1, %xmm0
; FAST-NEXT:    setnp %al
; FAST-NEXT:    sete %cl
; FAST-NEXT:    testb %al, %cl
; FAST-NEXT:    cmoveq %rsi, %rdi
; FAST-NEXT:    movq %rdi, %rax
; FAST-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_oeq_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm1, %xmm0
; FAST_AVX-NEXT:    setnp %al
; FAST_AVX-NEXT:    sete %cl
; FAST_AVX-NEXT:    testb %al, %cl
; FAST_AVX-NEXT:    cmoveq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp oeq double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_ogt_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_ogt_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm1, %xmm0
; NOAVX-NEXT:    cmovbeq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_ogt_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm1, %xmm0
; FAST_AVX-NEXT:    cmovbeq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ogt double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_oge_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_oge_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm1, %xmm0
; NOAVX-NEXT:    cmovbq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_oge_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm1, %xmm0
; FAST_AVX-NEXT:    cmovbq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp oge double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_olt_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_olt_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm0, %xmm1
; NOAVX-NEXT:    cmovbeq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_olt_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm0, %xmm1
; FAST_AVX-NEXT:    cmovbeq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp olt double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_ole_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_ole_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm0, %xmm1
; NOAVX-NEXT:    cmovbq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_ole_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm0, %xmm1
; FAST_AVX-NEXT:    cmovbq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ole double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_one_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_one_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm1, %xmm0
; NOAVX-NEXT:    cmoveq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_one_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm1, %xmm0
; FAST_AVX-NEXT:    cmoveq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp one double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_ord_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_ord_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm1, %xmm0
; NOAVX-NEXT:    cmovpq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_ord_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm1, %xmm0
; FAST_AVX-NEXT:    cmovpq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ord double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_uno_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_uno_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm1, %xmm0
; NOAVX-NEXT:    cmovnpq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_uno_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm1, %xmm0
; FAST_AVX-NEXT:    cmovnpq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp uno double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_ueq_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_ueq_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm1, %xmm0
; NOAVX-NEXT:    cmovneq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_ueq_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm1, %xmm0
; FAST_AVX-NEXT:    cmovneq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ueq double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_ugt_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_ugt_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm0, %xmm1
; NOAVX-NEXT:    cmovaeq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_ugt_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm0, %xmm1
; FAST_AVX-NEXT:    cmovaeq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ugt double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_uge_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_uge_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm0, %xmm1
; NOAVX-NEXT:    cmovaq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_uge_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm0, %xmm1
; FAST_AVX-NEXT:    cmovaq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp uge double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_ult_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_ult_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm1, %xmm0
; NOAVX-NEXT:    cmovaeq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_ult_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm1, %xmm0
; FAST_AVX-NEXT:    cmovaeq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ult double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_ule_cmov(double %a, double %b, i64 %c, i64 %d) {
; NOAVX-LABEL: select_fcmp_ule_cmov:
; NOAVX:       ## BB#0:
; NOAVX-NEXT:    ucomisd %xmm1, %xmm0
; NOAVX-NEXT:    cmovaq %rsi, %rdi
; NOAVX-NEXT:    movq %rdi, %rax
; NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_ule_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm1, %xmm0
; FAST_AVX-NEXT:    cmovaq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ule double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_une_cmov(double %a, double %b, i64 %c, i64 %d) {
; SDAG-LABEL: select_fcmp_une_cmov:
; SDAG:       ## BB#0:
; SDAG-NEXT:    ucomisd %xmm1, %xmm0
; SDAG-NEXT:    cmovneq %rdi, %rsi
; SDAG-NEXT:    cmovpq %rdi, %rsi
; SDAG-NEXT:    movq %rsi, %rax
; SDAG-NEXT:    retq
;
; FAST-LABEL: select_fcmp_une_cmov:
; FAST:       ## BB#0:
; FAST-NEXT:    ucomisd %xmm1, %xmm0
; FAST-NEXT:    setp %al
; FAST-NEXT:    setne %cl
; FAST-NEXT:    orb %al, %cl
; FAST-NEXT:    cmoveq %rsi, %rdi
; FAST-NEXT:    movq %rdi, %rax
; FAST-NEXT:    retq
;
; FAST_AVX-LABEL: select_fcmp_une_cmov:
; FAST_AVX:       ## BB#0:
; FAST_AVX-NEXT:    vucomisd %xmm1, %xmm0
; FAST_AVX-NEXT:    setp %al
; FAST_AVX-NEXT:    setne %cl
; FAST_AVX-NEXT:    orb %al, %cl
; FAST_AVX-NEXT:    cmoveq %rsi, %rdi
; FAST_AVX-NEXT:    movq %rdi, %rax
; FAST_AVX-NEXT:    retq
  %1 = fcmp une double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_fcmp_true_cmov(double %a, double %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_fcmp_true_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %1 = fcmp true double %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_icmp_eq_cmov(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_icmp_eq_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmovneq %rcx, %rdx
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    retq
  %1 = icmp eq i64 %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_icmp_ne_cmov(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_icmp_ne_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmoveq %rcx, %rdx
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    retq
  %1 = icmp ne i64 %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_icmp_ugt_cmov(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_icmp_ugt_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmovbeq %rcx, %rdx
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    retq
  %1 = icmp ugt i64 %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}


define i64 @select_icmp_uge_cmov(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_icmp_uge_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmovbq %rcx, %rdx
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    retq
  %1 = icmp uge i64 %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_icmp_ult_cmov(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_icmp_ult_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmovaeq %rcx, %rdx
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    retq
  %1 = icmp ult i64 %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_icmp_ule_cmov(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_icmp_ule_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmovaq %rcx, %rdx
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    retq
  %1 = icmp ule i64 %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_icmp_sgt_cmov(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_icmp_sgt_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmovleq %rcx, %rdx
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    retq
  %1 = icmp sgt i64 %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_icmp_sge_cmov(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_icmp_sge_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmovlq %rcx, %rdx
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    retq
  %1 = icmp sge i64 %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_icmp_slt_cmov(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_icmp_slt_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmovgeq %rcx, %rdx
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    retq
  %1 = icmp slt i64 %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

define i64 @select_icmp_sle_cmov(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: select_icmp_sle_cmov:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmovgq %rcx, %rdx
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    retq
  %1 = icmp sle i64 %a, %b
  %2 = select i1 %1, i64 %c, i64 %d
  ret i64 %2
}

