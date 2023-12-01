pragma solidity ^0.8.23;

import "src/interfaces/IModule.sol";
import "src/interfaces/IMSA.sol";

contract MockValidator is IValidator {
    function enable(bytes calldata data) external override { }

    function disable(bytes calldata data) external override { }

    function validateUserOp(
        IERC4337.UserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    )
        external
        override
        returns (uint256)
    {
        bytes4 execSelector = bytes4(userOp.callData[:4]);

        if (execSelector != IMSA.execute.selector) revert InvalidExecution(execSelector);
        (address target, uint256 value, bytes memory callData) =
            abi.decode(userOp.callData[4:], (address, uint256, bytes));
        if (target == userOp.sender) revert InvalidTargetAddress(target);
    }

    function isValidSignature(
        bytes32 hash,
        bytes calldata data
    )
        external
        override
        returns (bytes4)
    { }
}