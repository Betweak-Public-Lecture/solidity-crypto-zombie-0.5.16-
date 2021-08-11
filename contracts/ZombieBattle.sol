pragma solidity ^0.5.16;

import "./ZombieHelper.sol";

contract ZombieBattle is ZombieHelper {
    uint256 randNonce = 0;
    uint256 attackVictoryProbability = 70;

    // 2. 난수 생성함수 만들기(Fake Random) // 승리했는지 안했는지 체크 위해 생성
    // a. 컨트랙트에 uint randNonce= 0;
    // b. randMod(uint _modulus)함수 생성 internal returns(uint256)
    // c. randNonce 증가시키고
    // d. return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus
    // 0.5버전에서는 해시하기전에 abi.encodePacked사
    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce++;

        return
            uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) %
            _modulus;
    }

    function attack(uint256 _zombieId, uint256 _targetId)
        external
        zombieOwnerOf(_zombieId)
    {
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie));
        Zombie storage enemyZombie = zombies[_targetId];

        uint256 rand = randMod(100); //0~99
        // rand (0<(승률):69) ==> 승리
        // rand (>=승률:70 ) ==> 패배
        if (rand < attackVictoryProbability) {
            // 우리 좀비가 승리한 경우
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);

            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            // 패배한 경우
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
        }
        _triggerCooldown(myZombie);
    }

    function setAttakVictoryProbability(uint256 _prob) external onlyOwner {
        require(0 <= _prob && _prob <= 100);

        attackVictoryProbability = _prob;
    }
}
