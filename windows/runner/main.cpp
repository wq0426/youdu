#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include <string>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // WebView2 默认把用户数据目录建在 exe 同级（<exe>.WebView2），
  // 安装到 Program Files 后普通权限不可写，会弹"无法创建数据目录"。
  // 统一指到用户可写的 %LOCALAPPDATA%\ydapp\WebView2（与应用数据同目录，卸载时一并清理）。
  // webview_windows 和 flutter_inappwebview 创建环境时均未显式指定数据目录，都会遵从该环境变量。
  if (::GetEnvironmentVariableW(L"WEBVIEW2_USER_DATA_FOLDER", nullptr, 0) == 0) {
    wchar_t local_app_data[MAX_PATH];
    if (::GetEnvironmentVariableW(L"LOCALAPPDATA", local_app_data, MAX_PATH) > 0) {
      std::wstring webview_data_dir =
          std::wstring(local_app_data) + L"\\ydapp\\WebView2";
      ::SetEnvironmentVariableW(L"WEBVIEW2_USER_DATA_FOLDER",
                                webview_data_dir.c_str());
    }
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(960, 675);  // 75% of 1280x900
  if (!window.Create(L"Telegram", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
