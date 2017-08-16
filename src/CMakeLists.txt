set (CONFIG_FILE ${CMAKE_CURRENT_BINARY_DIR}/Config.vala)
configure_file (${CMAKE_SOURCE_DIR}/Config.vala.cmake ${CONFIG_FILE})

vala_precompile (VALA_C ${CMAKE_PROJECT_NAME}
    ${CONFIG_FILE}
    Widgets/MatchItem.vala
    Settings.vala
    MainWindow.vala
    Application.vala
PACKAGES
    granite
    gtk+-3.0
OPTIONS
    --vapidir=${CMAKE_SOURCE_DIR}/vapi
    --target-glib=2.32
    --thread
)

add_executable (${CMAKE_PROJECT_NAME} ${VALA_C})
target_link_libraries (${CMAKE_PROJECT_NAME} ${DEPS_LIBRARIES})

# Installation
install (TARGETS ${CMAKE_PROJECT_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_FULL_BINDIR})
