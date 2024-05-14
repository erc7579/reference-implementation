// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {
    IValidator,
    PackedUserOperation,
    VALIDATION_SUCCESS,
    MODULE_TYPE_VALIDATOR
} from "src/interfaces/IERC7579Module.sol";

import "forge-std/interfaces/IERC165.sol";

contract MockValidator is IValidator {
    function onInstall(bytes calldata data) external override { }

    function onUninstall(bytes calldata data) external override { }

    function validateUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash
    )
        external
        override
        returns (uint256)
    {
        bytes4 execSelector = bytes4(userOp.callData[:4]);

        return VALIDATION_SUCCESS;
    }

    function isValidSignatureWithSender(
        address sender,
        bytes32 hash,
        bytes calldata data
    )
        external
        view
        override
        returns (bytes4)
    {
        return 0x1626ba7e;
    }

    function isModuleType(uint256 moduleTypeId) external view returns (bool) {
        return moduleTypeId == MODULE_TYPE_VALIDATOR;
    }

    function isInitialized(address smartAccount) external view returns (bool) {
        return false;
    }

    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
        if (interfaceId == type(IERC165).interfaceId) {
            return true;
        }
        if (interfaceId == type(IValidator).interfaceId) {
            return true;
        }
        if (interfaceId == IValidator.validateUserOp.selector) {
            return true;
        }

        if (interfaceId == IValidator.isValidSignatureWithSender.selector) {
            return true;
        }
    }
}
