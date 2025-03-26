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

    stack = function()
        return setmetatable({
            -- stack table  
            _stack = {},
            -- size of stack
            count = 0,

            -- push an element to the stack underlying array
            push = function(self, obj)
                -- increment the index
                self.count = self.count + 1
                -- set the element at the end of the array
                rawset(self._stack, self.count, obj)
            end,

            -- pop an element from the stack
            pop = function(self)
                -- decrement the index    
                self.count = self.count - 1
                -- remove and return the last element
                return table.remove(self._stack)
            end,
        }, {
            __index = function(self, index)
                return rawget(self._stack, index)
            end,
        })
    end
}