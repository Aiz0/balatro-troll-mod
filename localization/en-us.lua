return {
    misc = {
        dictionary = {
            k_folly_shoot_the_moon = "Shoot the moon!",
            k_folly_mega_jackpot = "Mega Jackpot!",
            k_folly_mansion = "Evil Billionaire Power",
            k_folly_cavendish = "Rotten!",
            k_folly_dr_house = "This Vexes Me",
            k_folly_drivers_license_expired = "Expired!",
            k_folly_renew_drivers_license = "Renew",
            k_folly_drivers_license_renewed = "Renewed!",
            k_folly_greed = "Greed!",
            k_folly_tc = "Level Up!",
            k_folly_tc_heal = "Heal!",
            k_folly_tc_damage = " Damage!",
            k_folly_tc_damage = "Defeat!",
            
            --Object Types
            k_funny = "Funny :)",
            b_funny_cards = "Funny :)",
        },
    },
    descriptions = {
        Joker = {
            j_folly_campfire_alt = {
                name = "Campfire",
                text = {
                    "This Joker gains {X:mult,C:white}X#1#{} Mult for",
                    "each card sold and loses {X:mult,C:white}X#1#{} Mult",
                    "for each hand played",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
                },
            },
            j_folly_charcoal = {
                name = "Charcoal",
                text = {
                    "You have to keep your",
                    "campfire lit, idiot",
                    "{C:mult}#1#{} Mult",
                    "Costs {C:money}$5{} to sell",
                    "because of carbon tax",
                },
            },
            j_folly_apartment = {
                name = "Apartment",
                text = {
                    "This Joker gains",
                    "Chips equal to the",
                    "{C:attention}lowest{} ranked card",
                    "held in hand",
                    "{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips)",
                },
            },
            j_folly_house = {
                name = "House",
                text = {
                    "Every played {C:attention}card{}",
                    "permanently gains",
                    "{C:mult}+1{} Mult when scored",
                },
            },
            j_folly_mansion = {
                name = "Mansion",
                text = {
                    "Reduces rank of",
                    "all {C:attention}scoring cards{}",
                    "in played hand",
                    "Gain {X:red,C:white}X#1#{} Mult",
                    "per rank reduced",
                    "{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult)",
                },
            },
            j_folly_dr_house = {
                name = "Dr. House",
                text = {
                    "{C:inactive}Debuffed {}cards still score.",
                    "{C:inactive}Debuffed{} cards",
                    "each give {X:mult,C:white}X#1#{} Mult",
                    "{C:dark_edition}But watch out!",
                },
            },

            j_folly_trading_alt = {
                name = "Trading Card",
                text = {
                    "If {C:attention}first discard{} of round",
                    "has only {C:attention}#1#{} card, destroy",
                    "it and earn {C:money}$#2#{}",
                },
            },
            j_folly_trading_alt_multiple = {
                name = "Trading Card",
                text = {
                    "If {C:attention}first discard{} of round",
                    "has up to {C:attention}#1#{} cards, destroy",
                    "them and earn {C:money}$#2#{}",
                    "per card destroyed",
                }
            },
            j_folly_common = {
                name = "Common",
                text = {
                    "It's {C:common}Common",
                    "{C:chips}+#1#{} Chips"
                },
            },
            j_folly_alien = {
                name = "Alien",
                text = {
                    "{C:chips}+#1#{} chips"
                }
            },
            j_folly_super_alien = {
                name = "Super Alien",
                text = {
                    "{C:mult}+#1#{} Mult"
                }
            },
            j_folly_giga_alien = {
                name = "Giga Alien",
                text = {
                    "{X:mult,C:white}X#1#{} Mult"
                }
            },
            j_folly_glorp_alien = {
                name = "Glorp",
                text = {
                    "TBD"
                }
            }
        },
        Enhanced = {
            m_folly_burnt = {
                name = "Burnt Card",
                text = {
                    "{C:mult}+#1#{} Mult for",
                    "each burnt card",
                    "scored this hand",
                },
            },
        },
        funny = {
            c_folly_six = {
                name = "Six",
                text = {
                    "What?",
                    "Converts up to",
                    "{C:attention}2{} selected cards",
                    "to {C:attention}this{} card",
                },
            },
        },
        Planet = {
            c_folly_strange_planet = {
                name = "Strange Planet",
                text = {
                    "Beware of what",
                    "lies beyond",
                    "the stars"
                }
            }
        }
    },
}
