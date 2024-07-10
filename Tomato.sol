// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "./Ownable.sol";

contract Tomatotoken is ERC20, Ownable {
    mapping(uint256 => uint256) public itemCosts;
    mapping(address => mapping(uint256 => uint256)) public playerItems;

    event ItemPurchased(address indexed player, uint256 indexed itemId, uint256 cost);

    constructor(uint256 initialSupply) ERC20("GameToken", "GTK") {
        _mint(msg.sender, initialSupply * 10 ** decimals());
        itemCosts[1] = 250; // Item 1: Cost: 250 tokens
        itemCosts[2] = 500; // Item 2: Cost: 500 tokens
        itemCosts[3] = 1500; // Item 3: Cost: 1500 tokens
        itemCosts[4] = 3000; // Item 4: Cost: 3000 tokens
    }

     function updateItemCost(uint256 itemId, uint256 newCost) external onlyOwner {
        itemCosts[itemId] = newCost;
    }

    function mintTokens(address recipient, uint256 amount) external onlyOwner {
        _mint(recipient, amount);
    }

    function burnAllUserTokens(address user) external onlyOwner {
        uint256 userBalance = balanceOf(user);
        _burn(user, userBalance);
    }

    function burnTokens(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function purchaseItem(uint256 itemId) external {
        // Ensure item cost is set and player has enough balance
        require(itemCosts[itemId] > 0, "Item cost not set");
        require(balanceOf(msg.sender) >= itemCosts[itemId], "Insufficient balance");

        // Transfer tokens from player to owner (in-game store)
        _transfer(msg.sender, owner, itemCosts[itemId]);

        // Add the purchased item to player's inventory
        playerItems[msg.sender][itemId]++;

        emit ItemPurchased(msg.sender, itemId, itemCosts[itemId]);
    }
}
