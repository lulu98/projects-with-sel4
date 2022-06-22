import pytest
import pexpect
import time

def test_helloWorld(qemu_sim_cmd):
    child = pexpect.spawn(qemu_sim_cmd)
    child.expect('Component printer saying: My message.', timeout=20)
    t0 = time.time()
    i = 0
    while i < 4:
        child.expect('Component printer saying: My message.', timeout=20)
        t1 = time.time()
        timeDiff = t1 - t0
        assert (timeDiff >= 1.5 and timeDiff <= 2.5)
        t0 = t1
        i = i+1
    child.sendline('shutdown -h now')
