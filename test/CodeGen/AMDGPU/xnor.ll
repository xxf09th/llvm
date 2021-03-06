; RUN: llc -march=amdgcn -mcpu=gfx600 -verify-machineinstrs < %s | FileCheck --check-prefix=GCN --check-prefix=GFX600 %s
; RUN: llc -march=amdgcn -mcpu=gfx700 -verify-machineinstrs < %s | FileCheck --check-prefix=GCN --check-prefix=GFX700 %s
; RUN: llc -march=amdgcn -mcpu=gfx801 -verify-machineinstrs < %s | FileCheck --check-prefix=GCN --check-prefix=GFX801 %s
; RUN: llc -march=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck --check-prefix=GCN --check-prefix=GFX900 %s
; RUN: llc -march=amdgcn -mcpu=gfx906 -verify-machineinstrs < %s | FileCheck --check-prefix=GCN-DL --check-prefix=GFX906 %s

; GCN-LABEL: {{^}}scalar_xnor_i32_one_use
; GCN: s_xnor_b32
define amdgpu_kernel void @scalar_xnor_i32_one_use(
    i32 addrspace(1)* %r0, i32 %a, i32 %b) {
entry:
  %xor = xor i32 %a, %b
  %r0.val = xor i32 %xor, -1
  store i32 %r0.val, i32 addrspace(1)* %r0
  ret void
}

; GCN-LABEL: {{^}}scalar_xnor_i32_mul_use
; GCN-NOT: s_xnor_b32
; GCN: s_xor_b32
; GCN: s_not_b32
; GCN: s_add_i32
define amdgpu_kernel void @scalar_xnor_i32_mul_use(
    i32 addrspace(1)* %r0, i32 addrspace(1)* %r1, i32 %a, i32 %b) {
entry:
  %xor = xor i32 %a, %b
  %r0.val = xor i32 %xor, -1
  %r1.val = add i32 %xor, %a
  store i32 %r0.val, i32 addrspace(1)* %r0
  store i32 %r1.val, i32 addrspace(1)* %r1
  ret void
}

; GCN-LABEL: {{^}}scalar_xnor_i64_one_use
; GCN: s_xnor_b64
define amdgpu_kernel void @scalar_xnor_i64_one_use(
    i64 addrspace(1)* %r0, i64 %a, i64 %b) {
entry:
  %xor = xor i64 %a, %b
  %r0.val = xor i64 %xor, -1
  store i64 %r0.val, i64 addrspace(1)* %r0
  ret void
}

; GCN-LABEL: {{^}}scalar_xnor_i64_mul_use
; GCN-NOT: s_xnor_b64
; GCN: s_xor_b64
; GCN: s_not_b64
; GCN: s_add_u32
; GCN: s_addc_u32
define amdgpu_kernel void @scalar_xnor_i64_mul_use(
    i64 addrspace(1)* %r0, i64 addrspace(1)* %r1, i64 %a, i64 %b) {
entry:
  %xor = xor i64 %a, %b
  %r0.val = xor i64 %xor, -1
  %r1.val = add i64 %xor, %a
  store i64 %r0.val, i64 addrspace(1)* %r0
  store i64 %r1.val, i64 addrspace(1)* %r1
  ret void
}

; GCN-LABEL: {{^}}vector_xnor_i32_one_use
; GCN-NOT: s_xnor_b32
; GCN: v_xor_b32
; GCN: v_not_b32
; GCN-DL: v_xnor_b32
define i32 @vector_xnor_i32_one_use(i32 %a, i32 %b) {
entry:
  %xor = xor i32 %a, %b
  %r = xor i32 %xor, -1
  ret i32 %r
}

; GCN-LABEL: {{^}}vector_xnor_i64_one_use
; GCN-NOT: s_xnor_b64
; GCN: v_xor_b32
; GCN: v_xor_b32
; GCN: v_not_b32
; GCN: v_not_b32
; GCN-DL: v_xnor_b32
; GCN-DL: v_xnor_b32
define i64 @vector_xnor_i64_one_use(i64 %a, i64 %b) {
entry:
  %xor = xor i64 %a, %b
  %r = xor i64 %xor, -1
  ret i64 %r
}
