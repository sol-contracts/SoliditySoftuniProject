pragma solidity ^0.4.21;

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
    struct Product{
        string name;
        uint price;
        uint quantity;
    }
    mapping(bytes32=>Product) products;
    bytes32[] productIndeces;
    function Marketplace() public {}
    
    function buy(bytes32 ID, uint quantity) external payable {
        ReduceProductQuantity(ID, quantity);
    }
    
    function update(bytes32 ID, uint newQuantity) external {
        products[ID].quantity = newQuantity;
    }

     //creates a new product and returns its ID
    function newProduct(string name, uint price, uint quantity) external returns(bytes32) {
        bytes32 productId = keccak256(name);
        products[productId] = Product(name, price, quantity);
        productIndeces.push(productId);
        return productId;
    }
    
    function getProduct(bytes32 ID) external view returns(string name, uint price, uint quantity) {
        
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
}
