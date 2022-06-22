import pytest

def pytest_addoption(parser):
    parser.addoption("--qemu_sim_cmd", action="store", default="default name")


def pytest_generate_tests(metafunc):
    # This is called for every test. Only get/set command line arguments
    # if the argument is specified in the list of test "fixturenames".
    option_value = metafunc.config.option.qemu_sim_cmd
    if 'qemu_sim_cmd' in metafunc.fixturenames and option_value is not None:
        metafunc.parametrize("qemu_sim_cmd", [option_value])
