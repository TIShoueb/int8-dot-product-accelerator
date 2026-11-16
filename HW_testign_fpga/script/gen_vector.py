#!/usr/bin/env python3
# gen_vectors.py - generate test jobs + expected results for mac_bist
# Output line format (84 bits = 21 hex digits): a0 b0 a1 b1 a2 b2 a3 b3 expected

import random

# ---------------- settings ----------------
N_JOBS = 64
OUTPUT = "vectors.mem"
random.seed(1)                 # fixed seed -> reproducible file


# ---------------- hex helpers ----------------
def h8(x):
    return f"{x & 0xFF:02X}"      # 8-bit value -> 2 hex digits

def h20(x):
    return f"{x & 0xFFFFF:05X}"   # 20-bit value -> 5 hex digits


# ---------------- jobs ----------------
# each job = ( [a0, a1, a2, a3], [b0, b1, b2, b3] )
jobs = [
    ([-128] * 4, [-128] * 4),               # max result  +65536
    ([-128] * 4, [ 127] * 4),               # min result  -65024
    ([0] * 4,    [0] * 4),                  # zero
    ([3, -2, 7, -128], [4, 5, -1, -128]),   # mixed signs
    ([-1] * 4,   [-1] * 4),                 # negative x negative
    ([127] * 4,  [127] * 4),                # largest positive
]
# TODO: add random jobs until len(jobs) == N_JOBS
while len(jobs) < N_JOBS:
    a = [random.randint(-128, 127) for _ in range(4)]
    b = [random.randint(-128, 127) for _ in range(4)]
    jobs.append((a, b))
# ---------------- write the file ----------------
with open(OUTPUT, "w") as f:
    for a, b in jobs:
        expected = sum(x * y for x, y in zip(a, b))   #zip returns pair of a,b for i index
        word = ""
        for i in range(4):
            word += h8(a[i]) + h8(b[i]) 
        word += h20(expected)                              # then the expected result
        f.write(word + "\n")

print(f"wrote {len(jobs)} jobs to vectors.mem")