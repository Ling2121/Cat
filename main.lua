
require"cat"

local all_test = {
    bump_test = require"test/bump_test",
    scene_test = require"test/scene_test",
}
local test_module = "scene_test"

all_test[test_module]()