pragma solidity ^0.5.16;

import "./ZombieFactory.sol";

interface KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

contract ZombieFeeding is ZombieFactory {
    KittyInterface kittyInterface; // 선언만함. 값 대입 X

    function setKittyContractAddress(address _address) external onlyOwner {
        kittyInterface = KittyInterface(_address);
    }

    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) internal zombieOwnerOf(_zombieId) {
        // 3. 먹이를 먹는 대상 좀비 가져오기
        Zombie storage zombie = zombies[_zombieId];
        require(_isReady(zombie));

        uint256 newDna = (zombie.dna + _targetDna).div(2);
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("kitty"))
        ) {
            newDna = newDna.sub((newDna.mod(100))).add(99);
        }
        _createZombie("NoName", newDna);

        _triggerCooldown(zombie);
    }

    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;
        (, , , , , , , , , kittyDna) = kittyInterface.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return now >= _zombie.readyTime;
    }
}
