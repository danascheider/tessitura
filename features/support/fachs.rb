module Fachs
  module Data
    FACHS = [
      {
        id: 1,
        type: "soprano",
        quality: "lyric",
        coloratura: true
      },
      {
        id: 2,
        type: "soprano",
        quality: "lyric",
        coloratura: false
      },
      {
        id: 3,
        type: "soprano",
        quality: "dramatic",
        coloratura: true
      },
      {
        id: 4,
        type: "soprano",
        quality: "dramatic",
        coloratura: false
      },
      {
        id: 5,
        type: "mezzo-soprano",
        quality: "lyric",
        coloratura: true
      },
      {
        id: 6,
        type: "mezzo-soprano",
        quality: "lyric",
        coloratura: false
      },
      {
        id: 7,
        type: "mezzo-soprano",
        quality: "dramatic",
        coloratura: true
      },
      {
        id: 8,
        type: "mezzo-soprano",
        quality: "dramatic",
        coloratura: true
      },
      {
        id: 9,
        type: "contralto",
        quality: nil,
        coloratura: true
      },
      {
        id: 10,
        type: "contralto",
        quality: nil,
        coloratura: false
      },
      {
        id: 11,
        type: "countertenor",
        quality: nil,
        coloratura: nil
      },
      {
        id: 12,
        type: "tenor",
        quality: "lyric",
        coloratura: true
      },
      {
        id: 13,
        type: "tenor",
        quality: "lyric",
        coloratura: false
      },
      {
        id: 14,
        type: "tenor",
        quality: "dramatic",
        coloratura: false
      },
      {
        id: 15,
        type: "baritone",
        quality: "lyric",
        coloratura: true
      },
      {
        id: 16,
        type: "baritone",
        quality: "lyric",
        coloratura: false
      },
      {
        id: 17,
        type: "baritone",
        quality: "dramatic",
        coloratura: true
      },
      {
        id: 18,
        type: "baritone",
        quality: "dramatic",
        coloratura: false
      },
      {
        id: 19,
        type: "bass",
        quality:  "lyric",
        coloratura: true,
      },
      {
        id: 20,
        type: "bass",
        quality:  "dramatic",
        coloratura:  true
      },
      {
        id: 21,
        type: "bass",
        quality: "dramatic",
        coloratura:  false
      }
    ]
  end

  def self.fachs
    Fachs::Data::FACHS
  end
end