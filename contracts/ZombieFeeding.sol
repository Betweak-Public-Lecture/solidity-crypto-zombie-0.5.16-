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
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyInterface = KittyInterface(ckAddress);

    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string _species
    ) public {
        // 2. 주인만이 먹이를 줄 수 있도록 구성(require문 활용)
        require(msg.sender == zombieToOwner[_zombieId]);
        // 3. 먹이를 먹는 대상 좀비 가져오기
        Zombie storage zombie = zombies[_zombieId];

        uint256 newDna = (zombie.dna + _targetDna) / 2;
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("kitty"))
        ) {
            newDna = newDna - (newDna % 100) + 99;
        }
        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;
        (, , , , , , , , , kittyDna) = kittyInterface.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
