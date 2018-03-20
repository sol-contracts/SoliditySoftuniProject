pragma solidity ^0.4.21;

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


interface IMarketplace {
    function buy(bytes32 ID, uint quantity) external payable;
    
    function update(bytes32 ID, uint newQuantity) external;
    
    //creates a new product and returns its ID
    function newProduct(string name, uint price, uint quantity) external returns(bytes32);
    
    function getProduct(bytes32 ID) external view returns(string name, uint price, uint quantity);
    
    function getProducts() external view returns(bytes32[]);
    
    function getPrice(bytes32 ID, uint quantity) external view returns (uint);
}

contract Marketplace is IMarketplace {
    using SafeMath for uint;
    address owner;
    struct Product{
        string name;
        uint price;
        uint quantity;
    }
    mapping(bytes32=>Product) products;
    bytes32[] productIndeces;
    
    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }
    modifier enoughStockEnoughFunds (bytes32 ID, uint quantity) {
        require(products[ID].quantity>=quantity&&msg.value>=products[ID].price.mul(quantity));
_       ;
        
    }
    function Marketplace() public {
        owner=msg.sender;
    }
    
    function buy(bytes32 ID, uint quantity) external payable enoughStockEnoughFunds(ID, quantity) {
        ReduceProductQuantity(ID, quantity);
    }
    
    function update(bytes32 ID, uint newQuantity) external onlyOwner{
        require(msg.sender==owner);
        products[ID].quantity = newQuantity;
    }

     //creates a new product and returns its ID
    function newProduct(string name, uint price, uint quantity) external onlyOwner returns(bytes32) {
        bytes32 productId = keccak256(name);
        products[productId] = Product(name, price, quantity);
        productIndeces.push(productId);
        return productId;
    }
    
    function getProduct(bytes32 ID) external view returns(string name, uint price, uint quantity) {
        return (products[ID].name, products[ID].price, products[ID].quantity);
    }

    function getProducts() external view returns(bytes32[]) {
         return productIndeces;
    }
    
    function getPrice(bytes32 ID, uint quantity) external view returns (uint) {
        return products[ID].price;
    }
    
    function ReduceProductQuantity(bytes32 ID, uint quantity) internal{
        products[ID].quantity-=quantity;
    }
    
    function Withdraw(uint amount) public onlyOwner{
        owner.transfer(amount);
    }
}
