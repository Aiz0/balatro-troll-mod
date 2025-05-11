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
        joker = "j_" .. SMODS.current_mod.prefix .. "_",
    },

    log = {
        Trace = function(message)
            sendTraceMessage(message, display_name)
        end,
        Debug = function(message)
            sendDebugMessage(message, display_name)
        end,
        Info = function(message)
            sendInfoMessage(message, display_name)
        end,
        Warn = function(message)
            sendWarnMessage(message, display_name)
        end,
        Error = function(message)
            sendErrorMessage(message, display_name)
        end,
        Fatal = function(message)
            sendFatalMessage(message, display_name)
        end,
    },

    lerp = function(a, b, t)
        return a + (b - a) * t
    end,

    ---Shuffles Cards in cardarea.
    ---@param shuffles number? Defaults to 3
    ---@param area any? Defaults to G.jokers
    shuffle_cardarea = function(area, shuffles)
        shuffles = shuffles or 3
        area = area or G.jokers
        for i = 1, shuffles do
            G.E_MANAGER:add_event(Event({
                func = function()
                    area:shuffle("aajk")
                    play_sound("cardSlide1", 1)
                    return true
                end,
            }))
            delay(0.15)
        end
        delay(0.35) --extra delay when done
    end,

    get_previous_rank = function(key, offset)
        offset = offset or 1
        if offset <= 0 then
            return key
        end
        return get_previous_rank(SMODS.Ranks[key].prev[1], offset - 1)
    end,

    pseudorandom_range = function(min, max, seed)
        return folly_utils.lerp(min, max, pseudorandom(seed))
    end,
}
