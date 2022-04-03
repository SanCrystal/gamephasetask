// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;


import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  uint256 public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller,uint256 amountOfEth);
  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable returns(bool){
    uint256 amountOfTokens = tokensPerEth * msg.value;
    yourToken.transfer(msg.sender,amountOfTokens);
    emit BuyTokens(msg.sender, msg.value,amountOfTokens);
    return true;
  }
  // ToDo: create a withdraw() function that lets the owner withdraw ETH
function withdraw() external payable onlyOwner returns(bool){
  // require(address(this).balance >0,"Insufficient Funds for withrawal.");
  payable(msg.sender).transfer(address(this).balance);
  return true;
}
  // ToDo: create a sellTokens() function:
function sellTokens(uint256 amount) public returns(bool){
uint256 balance = yourToken.balanceOf(msg.sender);
uint256 amountOfEth = amount/tokensPerEth;

(bool sent)=yourToken.transferFrom(msg.sender,address(this),amount);
(sent,) = msg.sender.call{value:amountOfEth}("");
emit SellTokens(msg.sender,amount);
return true;
}

}
