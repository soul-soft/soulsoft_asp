package soulsoft_asp_authorization

import std.collection.*
import soulsoft_extensions_options.*

public class PassThroughAuthorizationHandler <: IAuthorizationHandler {
    private let _options: AuthorizationOptions

    public init(options: IOptions<AuthorizationOptions>) {
        _options = options.value
    }

    public func handle(context: AuthorizationHandlerContext) {
        let handlers = context.requirements |> filterMap {f => f as IAuthorizationHandler}
        for (pattern in handlers) {
            pattern.handle(context)
            if (!_options.invokeHandlersAfterFailure && context.hasFailed) {
                break
            }
        }
    }
}
