import pytest
import pexpect

def test_helloWorld(qemu_sim_cmd):
    child = pexpect.spawn(qemu_sim_cmd)
    child.expect('Hello CAmkES World', timeout=20)
    child.sendline('shutdown -h now')
