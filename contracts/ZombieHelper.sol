pragma solidity ^0.5.16;

import "./ZombieFeeding.sol";

// ZombieHelper.sol 생성 후 ZombieFeeding 상속
// 2. ZombieHelper에서, aboveLevel이라는 이름의 modifier 생성.
// 이 제어자는 _level(uint), _zombieId(uint) 두 개의 인수.
// 3. 함수 내용에서는 zombies[_zombieId].level이 _level 이상인지 확인.
// 주의: _; 의 역할 확인!

contract ZombieHelper is ZombieFeeding {
    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }
}
