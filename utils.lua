local display_name = SMODS.current_mod.display_name
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
            sendTraceMessage(message, display_name);
        end,
        Debug = function(message)
            sendDebugMessage(message, display_name);
        end,
        Info = function(message)
            sendInfoMessage(message,display_name);
        end,
        Warn = function(message)
            sendWarnMessage(message,display_name);
        end,
        Error = function(message)
            sendErrorMessage(message, display_name);
        end,
        Fatal = function(message)
            sendFatalMessage(message, display_name);
        end,
    },
    
    
    lerp = function(a, b, t)
        return a + (b - a) * t
    end,

    ---Shuffles Jokers in Joker area.
    ---@param shuffles number? Defaults to 3
    shuffle_jokers = function(shuffles)
        shuffles = shuffles or 3
        for i = 1, shuffles do
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.jokers:shuffle("aajk")
                    play_sound("cardSlide1", 1)
                    return true
                end,
            }))
            delay(0.15)
        end
        delay(0.35) --extra delay when done
    end,
}