#ifndef FFMPEG_H
#define FFMPEG_H

#include "Logger.h"
#include "Dependency.h"
#include "FfmpegAudioDetails.h"
#include "ExternalProcess.h"
#include "NetworkRequest.h"
#include "GitHubAPI.h"
#include "ArchiveHandler.h"
#include "Paths.h"
#include "CodecFactory.h"
#include "StringUtils.h"

#if __APPLE__
#include <nlohmann/json.hpp>
#endif

#include <regex>
#include <filesystem>

class Ffmpeg : public Dependency<Ffmpeg>
{
    friend class Dependency<Ffmpeg>;

    public:
        static FfmpegAudioDetails GetAudioDetails(const std::filesystem::path& filePath, const bool& getVolumeDetails = true);

        static std::filesystem::path Convert(const std::filesystem::path& currentPath, const EExtension& newExtension, const bool& deleteOriginal = true, std::function<void(float)> progressCallback = nullptr);

        static bool Normalise(const std::filesystem::path& filePath, const std::function<float(const FfmpegAudioDetails&)>& gainFunction, std::function<void(float)> progressCallback = nullptr);
        static bool NormaliseLoudness(const std::filesystem::path& filePath, const float& targetLUFS, std::function<void(float)> progressCallback = nullptr);
        static bool NormalisePeak(const std::filesystem::path& filePath, const float& targetDb, std::function<void(float)> progressCallback = nullptr);

        static bool SetBitrate(const std::filesystem::path& filePath, const unsigned int& bitrate, std::function<void(float)> progressCallback = nullptr);
    private:
        static std::string DownloadExecutableImpl(std::filesystem::path path);
        static std::string UpdateExecutableImpl();
        static std::string GetVersionImpl();
        static std::string GetLatestVersionImpl();
        static std::string GetFileNameImpl();
        static std::vector<GitHubRelease> GetReleasesImpl(const int& resultsPerPage, const int& page);

        static std::string Execute(const FfmpegAudioDetails& audioDetails, const std::vector<std::string>& args, const std::function<void(float)>& progressCallback = nullptr);
    private:
        static inline const float MAXIMUM_TRUE_PEAK = -1.0;
};

#endif