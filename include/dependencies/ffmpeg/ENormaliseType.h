#ifndef ENORMALISETYPE_H
#define ENORMALISETYPE_H

#include <vector>
#include <string>

enum class ENormaliseType
{
    None,
    Loudness,
    Peak
};

static inline const std::vector<std::string> ENORMALISETYPE_NAMES = {
    "None",
    "Loudness",
    "Peak"
};

#endif