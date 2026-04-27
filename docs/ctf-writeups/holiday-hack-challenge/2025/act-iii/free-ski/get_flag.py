#! /usr/bin/env python3
"""
FreeSki CTF Solver

This script reconstructs the flag generation logic from the FreeSki challenge.

Reverse engineering findings:
-----------------------------
1. Each mountain contains an `encoded_flag` (byte string).
2. The flag is decoded by XORing each byte with a PRNG stream:
       decoded[i] = encoded_flag[i] ^ random.randint(0, 255)

3. The PRNG is seeded with a value (`product`) derived from collected treasures:
       product = (product << 8) ^ treasure_value

4. Treasure values are NOT random at runtime. They are deterministically generated:
   - RNG seeded with CRC32(mountain_name)
   - 5 treasure positions generated via pseudo-random deltas

5. Each treasure is represented as a 2D coordinate:
       (elevation, horizontal_position)

6. The game converts this into a 1D integer:
       treasure_id = elevation * 1000 + horizontal_position

7. The ordered list of these 5 treasure IDs forms the key used to decode the flag.

This script replicates the entire pipeline:
    mountain → treasure locations → treasure IDs → product → RNG → flag
"""

import binascii
import random
from functools import cached_property
from dataclasses import dataclass


# Constant used in the game to linearize 2D coordinates
MOUNTAIN_WIDTH = 1000


@dataclass
class Treasure:
    """
    Represents a treasure location and its corresponding ID.

     Attributes:
        elevation (int): The elevation of the treasure location.
        horizontal (int): The horizontal position of the treasure location.
        treasure_id (int): The 1D ID representing the treasure location.

    Methods:
        __str__: Returns a formatted string representation of the treasure.
    """
    elevation: int
    horizontal: int
    treasure_id: int

    def __str__(self) -> str:
        return (
            f"    Elevation: {self.elevation:5d}\n"
            f"    Horizontal: {self.horizontal:4d}\n"
            f"    ID: {self.treasure_id:12d}"
        )

@dataclass(frozen=True)
class Mountain:
    """
    Represents a mountain with its properties and treasure generation logic.

    Attributes:
         name (str): Name of the mountain
         height (int): Height of the mountain
         encoded_flag (bytes): The encoded flag associated with this mountain
         treasures (list): List of treasure locations and IDs

    Methods:
        calculate_treasure_locations: Generates treasure locations based on the mountain's name and height.
        treasures_collected: Returns the list of treasure IDs collected from this mountain.
    """
    name: str
    height: int
    encoded_flag: bytes

    def calculate_treasure_locations(self) -> list[Treasure]:
        """
        Returns list of (elevation, horizontal_position, treasure_id) for all 5 treasures.

        Based in reconstructed treasure generation from Mountain.GetTreasureLocations().

        The game seeds the RNG using:
            random.seed(crc32(mountain_name))

        Then generates 5 treasure positions using:
            - vertical delta: random.randint(200, 800)
            - horizontal delta: random.randint(-e_delta/4, +e_delta/4)

        Returns:
            List[Treasure]: List of Treasure objects containing elevation, horizontal position, and treasure ID.
        """

        # Deterministic seed based on mountain name
        seed = binascii.crc32(self.name.encode("utf-8"))
        rng = random.Random(seed)

        prev_height = self.height
        prev_horiz = 0
        locations: list[Treasure] = []

        # Generate 5 treasures with deterministic pseudo-random deltas
        # similar to how is done in the game logic and include the
        # conversion to treasure_id to simulate a collected treasure
        for _ in range(5):
            # Vertical movement down the mountain
            e_delta = rng.randint(200, 800)

            # Horizontal drift (bounded by slope)
            h_delta = rng.randint(int(-e_delta / 4), int(e_delta / 4))

            # Compute absolute position
            elevation = prev_height - e_delta
            horizontal_position = prev_horiz + h_delta

            # Convert 2D coordinate → 1D value (used to decode the flag in the game)
            treasure_id = elevation * MOUNTAIN_WIDTH + horizontal_position

            # Store as (elevation, horizontal_position, treasure_id)
            locations.append(Treasure(
                elevation=elevation,
                horizontal=horizontal_position,
                treasure_id=treasure_id
            ))

            # Update state for next iteration
            prev_height = elevation
            prev_horiz = horizontal_position

        return locations
    
    @cached_property
    def treasures(self):
        """
        Returns list of treasure locations and IDs for this mountain.
        """
        return self.calculate_treasure_locations()

    @property
    def treasure_ids(self):
        """
        Returns list of treasure IDs collected from this mountain.

        This simulates the in-game logic where the player collects
        treasures and the IDs are used to decode the flag.
        """
        return [t.treasure_id for t in self.treasures]


# All 7 mountains extracted from the game with their heights and encoded flags
mountains = [
    Mountain("Mount Snow", 3586, b'\x90\x00\x1d\xbc\x17b\xed6S"\xb0<Y\xd6\xce\x169\xae\xe9|\xe2Gs\xb7\xfdy\xcf5\x98'),
    Mountain("Aspen", 11211, b'U\xd7%x\xbfvj!\xfe\x9d\xb9\xc2\xd1k\x02y\x17\x9dK\x98\xf1\x92\x0f!\xf1\\\xa0\x1b\x0f'),
    Mountain("Whistler", 7156, b'\x1cN\x13\x1a\x97\xd4\xb2!\xf9\xf6\xd4#\xee\xebh\xecs.\x08M!hr9?\xde\x0c\x86\x02'),
    Mountain("Mount Baker", 10781, b'\xac\xf9#\xf4T\xf1%h\xbe3FI+h\r\x01V\xee\xc2C\x13\xf3\x97ef\xac\xe3z\x96'),
    Mountain("Mount Norquay", 6998, b'\x0c\x1c\xad!\xc6,\xec0\x0b+"\x9f@.\xc8\x13\xadb\x86\xea{\xfeS\xe0S\x85\x90\x03q'),
    Mountain("Mount Erciyes", 12848, b'n\xad\xb4l^I\xdb\xe1\xd0\x7f\x92\x92\x96\x1bq\xca`PvWg\x85\xb21^\x93F\x1a\xee'),
    Mountain("Dragonmount", 16282, b'Z\xf9\xdf\x7f_\x02\xd8\x89\x12\xd2\x11p\xb6\x96\x19\x05x))v\xc3\xecv\xf4\xe2\\\x9a\xbe\xb5'),
]

def decode_flag(encoded_flag: bytes, treasure_ids: list[int]) -> str:
    """
    Based on reconstructed SetFlag() decoding logic.

    Steps:
    1. Build the RNG seed (product) from the list of treasure IDs:
           product = (product << 8) ^ treasure_id

    2. Seed RNG with product.

    3. XOR each encoded byte with random stream.

    Returns:
        Decoded flag string
    """
    product = 0

    for treasure_id in treasure_ids:
        product = (product << 8) ^ treasure_id

    rng = random.Random(product)

    decoded = bytes(byte ^ rng.randint(0, 255) for byte in encoded_flag)
    return decoded.decode(errors='replace')  # Decode as UTF-8, replacing invalid bytes

def main():
    """
    For each mountain:
    - Reconstruct treasure locations
    - Convert locations to treasure IDs
    - Derive RNG seed
    - Decode flag
    """
    for mountain in mountains:
        print(f"\n{'=' * 60}")
        print(f"{mountain.name} (Height: {mountain.height})")
        print("Treasure locations:")
        print(f"{'-' * 60}")

        # Get information about the treasures in this mountain
        for i, treasure in enumerate(mountain.treasures, start=1):
            print(f"  Treasure {i}:")
            print(treasure)

        # Decode the flag for this mountain
        flag = decode_flag(mountain.encoded_flag, mountain.treasure_ids)

        print("\nDecoded Flag:")
        print(flag)


if __name__ == '__main__':
    main()
