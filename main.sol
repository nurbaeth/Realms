// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EthernalRealms is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;

    enum Class { Warrior, Mage, Rogue }

    struct Character {
        string name;
        Class classType;
        uint256 level;
        uint256 strength;
        uint256 intelligence;
        uint256 agility;
    }

    mapping(uint256 => Character) public characters;
    mapping(address => bool) public hasCharacter;

    constructor() ERC721("Ethernal Realms", "REALM") {}

    function createCharacter(
        string memory name,
        uint8 classType // 0: Warrior, 1: Mage, 2: Rogue
    ) external {
        require(!hasCharacter[msg.sender], "You already have a character");
        require(classType <= uint8(Class.Rogue), "Invalid class");

        uint256 tokenId = nextTokenId++;
        _safeMint(msg.sender, tokenId);

        // Set default stats based on class
        (uint256 strength, uint256 intelligence, uint256 agility) = _getClassStats(Class(classType));

        characters[tokenId] = Character({
            name: name,
            classType: Class(classType),
            level: 1,
            strength: strength,
            intelligence: intelligence,
            agility: agility
        });

        hasCharacter[msg.sender] = true;
    }

    function _getClassStats(Class classType) internal pure returns (uint256, uint256, uint256) {
        if (classType == Class.Warrior) {
            return (10, 2, 5);
        } else if (classType == Class.Mage) {
            return (2, 10, 5);
        } else {
            return (5, 4, 10); // Rogue
        }
    }

    function getCharacter(uint256 tokenId) external view returns (Character memory) {
        require(_exists(tokenId), "Character does not exist");
        return characters[tokenId];
    }
}
