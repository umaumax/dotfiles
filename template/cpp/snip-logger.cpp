#include <chrono>
#include <cinttypes>
#include <iostream>

class Logger {
 public:
  Logger(const std::string& filepath, const std::string& key) : key_(key) {
    file_ = fopen(filepath.c_str(), "w");
  }

  ~Logger() { fclose(file_); }

  template <class... T>
  void Print(const std::string& format, T&&... args) {
    uint64_t timestamp =
        std::chrono::duration_cast<std::chrono::milliseconds>(
            std::chrono::system_clock::now().time_since_epoch())
            .count();
    fprintf(file_, "%" PRIu64 " %s ", timestamp, key_.c_str());
    fprintf(file_, format.c_str(), std::forward<T>(args)...);
    fprintf(file_, "\n");
  }

 private:
  FILE* file_;
  std::string key_;
};

int main() {
  Logger logger("./tmp.log", "key");
  logger.Print("hello %s %d", "world", 123);
}
