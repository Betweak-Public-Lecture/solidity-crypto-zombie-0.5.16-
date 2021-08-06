pragma solidity ^0.5.16;

contract ZombieFactory {
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    // _createZombie 라는 private 함수 생성 인자는 2개 (string _name, uint _dna)
    function _createZombie(string _name, uint256 _dna) private {
        // 해당 함수는 전달받은 인자들로 새로운 Zombie를 생성하고 zombies배열에 추가하는 함수
        // Zombie zombie = Zombie(_name, _dna);
        // zombies.push(zombie);
        zombies.push(Zombie(_name, _dna));
    }
}
