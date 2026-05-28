{
  description = "Development environment for ShopSchedulingSolver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python3.withPackages (
          ps: with ps; [
            numpy
            plotly
            matplotlib
            streamlit
            gdown
            py7zr
          ]
        );

        config-solver = pkgs.writeShellScriptBin "config-solver" ''
          set -e
          echo "Configuring ShopSchedulingSolver..."

          cmake -S . -B build -DCMAKE_BUILD_TYPE=Release \
              -DSHOPSCHEDULINGSOLVER_USE_HIGHS=OFF \
              -DSHOPSCHEDULINGSOLVER_USE_OPTALCP=OFF \
              -DSHOPSCHEDULINGSOLVER_USE_ORTOOLS=OFF &> config.tmp

          echo "Configured ShopSchedulingSolver... (logs in 'config.tmp')"
        '';

        clean-solver = pkgs.writeShellScriptBin "clean-solver" ''
          set -e
          ${config-solver}/bin/config-solver
          echo "Cleaning ShopSchedulingSolver..."
          cmake --build build --config Release --target clean &> clean.tmp
          echo "Cleaned ShopSchedulingSolver... (logs in 'clean.tmp')"
        '';

        build-solver = pkgs.writeShellScriptBin "build-solver" ''
          set -e
          ${clean-solver}/bin/clean-solver
          echo "Compiling ShopSchedulingSolver..."
          cmake --build build --config Release --parallel &> compil.tmp
          echo "Compiled ShopSchedulingSolver... (logs in 'compil.tmp')"
        '';

        install-solver = pkgs.writeShellScriptBin "install-solver" ''
          set -e
          ${build-solver}/bin/build-solver
          echo "Installing ShopSchedulingSolver..."
          cmake --install build --config Release --prefix install &> inst.tmp
          echo "Installed ShopSchedulingSolver... (logs in 'inst.tmp')"
        '';

        test-solver = pkgs.writeShellScriptBin "test-solver" ''
          set -e
          ${install-solver}/bin/install-solver
          echo "Testing ShopSchedulingSolver..."
          ctest --parallel --output-on-failure --test-dir build/test "$@"\
             &> test.tmp
          echo "Tested ShopSchedulingSolver... (logs in 'test.tmp')"
        '';

        run-solver = pkgs.writeShellScriptBin "run-solver" ''
          set -e
          ./install/bin/shopschedulingsolver "$@"
        '';

        visualize = pkgs.writeShellScriptBin "visualize" ''
          set -e
          python ./scripts/visualize.py "$@"
        '';

      in
      {
        packages.config-solver = config-solver;
        packages.clean-solver = clean-solver;
        packages.build-solver = build-solver;
        packages.install-solver = install-solver;
        packages.test-solver = test-solver;
        packages.run-solver = run-solver;
        packages.visualize = visualize;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config
            git
            nodejs
            nodePackages.typescript
            nodePackages.npm
            go
            config-solver
            clean-solver
            build-solver
            install-solver
            test-solver
            run-solver
            visualize
          ];

          buildInputs =
            with pkgs;
            [
              # C++ libraries
              boost
              highs
              cbc
              nlohmann_json

              # Python environment
              pythonEnv
            ]
            ++ lib.optionals stdenv.isDarwin [
              libiconv
            ];

          shellHook = ''
            export ORTOOLSDIR="/Users/dylan/OR-TOOLS/or-tools_arm64_macOS-15.3.1_cpp_v9.12.4544"
            export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$ORTOOLSDIR/lib"
            npm install

            echo ""
            echo "===================================================="
            echo " ShopSchedulingSolver development environment loaded"
            echo "===================================================="
            echo ""
            echo "Run 'config-solver' to configure the project."
            echo "Run 'clean-solver' to clean the project."
            echo "Run 'build-solver' to build the project."
            echo "Run 'install-solver' to install the project."
            echo "Run 'test-solver [opts]' to run tests."
            echo "Run 'run-solver --input <input> --format <format>"
            echo "      --objective <objective> --algorithm <algorithm>"
            echo "      --certificate <certificate>' to run the solver."
            echo "Run 'visualize <solution>' to visualize the provided\
              solution."
            echo ""
          '';
        };
      }
    );
}
