// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Import this file to use console.log
import "hardhat/console.sol";

contract BuyMeACoffee {
    // Event to emit when a Memo is created
    event NewMeMo(
        address indexed from, 
        uint256 timestamp,
        string name, 
        string message
    );

    struct Memo {
        address from ;
        uint256 timestamp;
        string name;
        string message;
    }

    // Address of contract deployer, Marked payable so that 
    // we can withdraw to this address later.
    address payable owner;

    // List of all memos received from coffee purchases.
    Memo[] memos;

    constructor() {
        owner = payable(msg.sender);
    }

    /**
     * @dev fethes all stored memos 
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    /**
     * @dev buy a coffee for owner ( sends an ETH tip and leaves a momo )
     * @param _name name of the coffee purchaser 
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        // Must accept more than 0 ETH for a coffee. 
        require(msg.value > 0, "can't buy coffee for freee!");

        // Add the memo to storage!
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // Emit a NewMemo event with details about the momo.
        emit NewMeMo(msg.sender, block.timestamp, _name, _message);
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
     function withdrawTips() public {
        require(owner.send(address(this).balance));
     }
}
