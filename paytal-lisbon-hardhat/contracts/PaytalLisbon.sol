// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// import "chronicle-std/src/IChronicle.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

interface IChronicle {
    /// @notice Returns the oracle's identifier.
    /// @return wat The oracle's identifier.
    function wat() external view returns (bytes32 wat);

    /// @notice Returns the oracle's current value.
    /// @dev Reverts if no value set.
    /// @return value The oracle's current value.
    function read() external view returns (uint value);

    /// @notice Returns the oracle's current value and its age.
    /// @dev Reverts if no value set.
    /// @return value The oracle's current value.
    /// @return age The value's age.
    function readWithAge() external view returns (uint value, uint age);

    /// @notice Returns the oracle's current value.
    /// @return isValid True if value exists, false otherwise.
    /// @return value The oracle's current value if it exists, zero otherwise.
    function tryRead() external view returns (bool isValid, uint value);

    /// @notice Returns the oracle's current value and its age.
    /// @return isValid True if value exists, false otherwise.
    /// @return value The oracle's current value if it exists, zero otherwise.
    /// @return age The value's age if value exists, zero otherwise.
    function tryReadWithAge()
        external
        view
        returns (bool isValid, uint value, uint age);
}

enum Currency {
    USDC,
    ETH,
    GNO
}

struct Coin {
    uint256 amountInCoin;
    uint256 amountInUsd;
}

contract PaytalLisbon {

    uint constant public TOTAL_CURRENCIES = 3;

    mapping (Currency => address) tokenAddress;
    mapping (Currency => address) chronicleOracleAddress;

    constructor (
        address usdc,
        address eth,
        address gno,
        address usdcUsd,
        address ethUsd,
        address gnoUsd
    ) {
        tokenAddress[Currency.USDC] = usdc;
        tokenAddress[Currency.ETH] = eth;
        tokenAddress[Currency.GNO] = gno;
        chronicleOracleAddress[Currency.USDC] = usdcUsd;
        chronicleOracleAddress[Currency.ETH] = ethUsd;
        chronicleOracleAddress[Currency.GNO] = gnoUsd;
    }

    function getPriceCombination(
        uint256 price,
        address account
    ) public view returns(Coin[3] memory, bool success) {

        Coin[3] memory _coinResult;

        uint256[3] memory result;
        uint256[3] memory _tokenBalances;
        uint256 _balance;
        uint256 _totalAmount;
        uint256 _accum;
        uint256 _unit = 1e18;

        for (uint i=0; i < TOTAL_CURRENCIES; ++i) {
            Currency _currency = Currency(i);
            _balance = IERC20(tokenAddress[_currency]).balanceOf(account);
            uint256 _normBalance;

            // TODO: Patching decimals for USDC
            if (i == 0) {_normBalance = _balance * 1e12;} else {_normBalance = _balance;}

            // _decimals = IERC20(tokenAddress[_currency]).decimals();
            uint256 priceInUsd = IChronicle(chronicleOracleAddress[_currency]).read();
            // uint256 priceInUsd = TEST_DATA[i];

            _totalAmount = priceInUsd * _normBalance / 1e18;
            _accum += _totalAmount;

            if (_accum >= price) {
                uint256 _valueInUsd = _totalAmount - (_accum - price);
                result[i] = _valueInUsd;
                uint256 value = (_valueInUsd * 1e18) / priceInUsd;
                if (i == 0) { value = value / 1e12; }
                _tokenBalances[i] = value;
                _coinResult[i] = Coin(value, _valueInUsd);
                break;
            } else {
                result[i] = _totalAmount;
                if (i == 0) { _normBalance = _normBalance / 1e12; }
                _tokenBalances[i] = _normBalance;
                _coinResult[i] = Coin(_normBalance, _totalAmount);
            }
        }

        return (_coinResult, _accum >= price);
    }
}
