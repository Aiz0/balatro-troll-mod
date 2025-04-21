folly_utils = {
    replace = function(card, other)
        G.E_MANAGER:add_event(Event({
            func = function()
                -- first play some sound effects and juice up card
                play_sound("tarot1")
                card.T.r = -0.2
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        SMODS.add_card({ -- creates new card and adds it to joker area
                            key = other, --key of joker to add
                            edition = card.edition, --keep edition
                            stickers = card.stickers, -- keep stickers
                        })
                        card:remove() -- remove original card
                        return true
                    end,
                }))
                return true
            end,
        }))
    end,

    prefix = {
        joker = "j_" .. SMODS.current_mod.prefix .. "_"
    },

    log = {
        Trace = function(message)
            sendTraceMessage(message, "Folly Jokers | Trace");
        end,
        Debug = function(message)
            sendDebugMessage(message, "Folly Jokers | Debug");
        end,
        Info = function(message)
            sendInfoMessage(message, "Folly Jokers | Info");
        end,
        Warn = function(message)
            sendWarnMessage(message, "Folly Jokers | Warn");
        end,
        Error = function(message)
            sendErrorMessage(message, "Folly Jokers | Error");
        end,
        Fatal = function(message)
            sendFatalMessage(message, "Folly Jokers | Fatal");
        end,
    },
}