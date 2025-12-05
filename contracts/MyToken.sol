// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    // --- Token metadata ---
    string public name = "MyToken";      // Token name
    string public symbol = "MTK";        // Token symbol
    uint8 public decimals = 18;          // Number of decimal places

    // Total supply of tokens (in smallest units, e.g., 1 MTK = 10^18 units)
    uint256 public totalSupply;

    // --- Mappings for balances and allowances ---

    // Tracks how many tokens each address owns
    mapping(address => uint256) public balanceOf;

    // Tracks how many tokens an owner allowed a spender to use
    // allowance[owner][spender] = amount
    mapping(address => mapping(address => uint256)) public allowance;

    // --- Events ---

    // Emitted when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Emitted when an approval is made
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // --- Constructor ---

    // _totalSupply should be passed INCLUDING decimals
    // e.g., for 1,000,000 MTK with 18 decimals:
    // _totalSupply = 1000000 * 10^18 = 1000000000000000000000000
    constructor(uint256 _totalSupply) {
        totalSupply = _totalSupply;

        // Give all tokens to the contract deployer
        balanceOf[msg.sender] = _totalSupply;

        // Emit a Transfer event from "address(0)" to show minting
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
        // Function to transfer tokens from caller to another address
        function transfer(address _to, uint256 _value) public returns (bool success) {
            // Validate that recipient is not zero address
            require(_to != address(0), "Cannot transfer to zero address");
            
            // Validate sender has sufficient balance
            require(balanceOf[msg.sender] >= _value, "Insufficient balance");
            
            // Subtract from sender's balance
            balanceOf[msg.sender] -= _value; 
            // Add to recipient's balance
            balanceOf[_to] += _value;
            
            // Emit Transfer event
            emit Transfer(msg.sender, _to, _value);
            
            return true;
        }
        //Function to approve another address to spend tokens on your behalf
        function approve(address _spender, uint256 _value) public returns (bool success) {
            // Validate spender is not zero address
            require(_spender != address(0), "Cannot approve zero address");
            // Validate approver has insufficient balance
            require(balanceOf[msg.sender] >= _value, "Insufficient balance");
            
            // Set allowance for spender
            allowance[msg.sender][_spender] = _value;
            
            // Emit Approval event
            emit Approval(msg.sender, _spender, _value);
            
            return true;
        }
        // Function to transfer tokens from an approved spender
        function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
            // Validate recipient is not zero address
            require(_to != address(0), "Cannot transfer to zero address");
            
            // Validate sender has sufficient balance
            require(balanceOf[_from] >= _value, "Insufficient balance");
            
            // Validate caller has sufficient allowance
                require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");
                
                // Subtract from owner's balance
                balanceOf[_from] -= _value;
                // Subtract from spender's allowance
                 allowance[_from][msg.sender] -= _value;
                // Add to recipient's balance
                balanceOf[_to] += _value;
                // Decrease allowance
                allowance[_from][msg.sender] -= _value;
                
                // Emit Transfer event
                emit Transfer(_from, _to, _value);
                
                return true;
            }
            // Function to get total supply (already public, but explicit function is clearer)
            function getTotalSupply() public view returns (uint256) {
                return totalSupply;
            }

            //Function to get token information as a single call
            function getTokenInfo() public view returns (string memory, string memory, uint8, uint256) {
                return (name, symbol, decimals, totalSupply);
            }
}