source plugin/ex_test.vim

call vspec#hint({"scope": "ex_test#scope()", "sid": "ex_test#sid()"})

let s:filename = "model_test.exs"

describe "RunTests"
  context "when g:ex_test_command is not defined"
    it "sets the default command"
      call Call("s:RunTests", s:filename)

      Expect Ref("s:ex_test_command") == "!clear && echo mix test model_test.exs && mix test model_test.exs"
    end

    context "when in GUI"
      context "when g:ex_test_runner is defined"
        before
          call Set("s:force_gui", 1)
          let s:original_runner = g:ex_test_runner
          let g:ex_test_runner = "iterm"
        end

        after
          let g:ex_test_runner = s:original_runner
          call Set("s:force_gui", 0)
        end

        it "sets the command with provided runner"
          let expected = "^silent ! '\.\*/bin/iterm' 'mix test " . s:filename . "'$"

          call Call("s:RunTests", s:filename)

          Expect Ref("s:ex_test_command") =~ expected
        end
      end

      context "when ex_test_runner is not defined"
        before
          call Set("s:force_gui", 1)
        end

        after
          call Set("s:force_gui", 0)
        end

        it "sets the command with default runner"
          let expected = "^silent ! '\.\*/bin/os_x_terminal' 'mix test " . s:filename . "'$"

          call Call("s:RunTests", s:filename)

          Expect Ref("s:ex_test_command") =~ expected
        end
      end
    end
  end

  context "when g:ex_test_command is defined"
    before
      call Set("s:force_gui", 0)
      let g:ex_test_command = "!Dispatch mix test {test}"
    end

    after
      unlet g:ex_test_command
    end

    context "when not in GUI"
      it "sets the provided command"
        let expected = "!Dispatch mix test " . s:filename

        call Call("s:RunTests", s:filename)

        Expect Ref("s:ex_test_command") == expected
      end
    end

    context "when in GUI"
      before
        call Set("s:force_gui", 1)
      end

      after
        call Set("s:force_gui", 0)
      end

      it "sets the provided GUI command"
        let expected = "^silent ! '\.\*/bin/os_x_terminal' '!Dispatch mix test " . s:filename . "'$"
        call Call("s:RunTests", s:filename)

        Expect Ref("s:ex_test_command") =~ expected
      end
    end
  end
end

describe "RunCurrentTestFile"
  context "when not in a spec file"
    before
      let g:ex_test_command = "!mix test {test}"
    end

    after
      unlet g:ex_test_command
    end

    context "when line number is not set"
      it "runs the last spec file"
        call Set("s:last_test_file", "model_test.exs")

        call Call("RunCurrentTestFile")

        Expect Ref("s:ex_test_command") == "!mix test model_test.exs"
      end
    end

    context "when line number is set"
      it "runs the last spec file"
        call Set("s:last_test_file", "model_test.exs")
        call Set("s:last_test_line", 42)

        call Call("RunCurrentTestFile")

        Expect Ref("s:ex_test_command") == "!mix test model_test.exs"
      end
    end
  end
end

describe "RunNearestTest"
  context "not in a spec file"
    before
      let g:ex_test_command = "!mix test {test}"
    end

    after
      unlet g:ex_test_command
    end

    it "runs the last spec file with line"
      call Set("s:last_test_file_with_line", "model_test.exs:42")

      call Call("RunNearestTest")

      Expect Ref("s:ex_test_command") == "!mix test model_test.exs:42"
    end
  end
end

describe "RunLastTest"
  before
    let g:ex_test_command = "!mix test {test}"
  end

  after
    unlet g:ex_test_command
  end

  context "when s:last_test is set"
    it "executes the last spec"
      call Set("s:last_test", "model_test.exs:42")

      call Call("RunLastTest")

      Expect Ref("s:ex_test_command") == "!mix test model_test.exs:42"
    end
  end
end

describe "RunAllTests"
  it "sets s:last_test to 'test'"
    call Call("RunAllTests")

    Expect Ref("s:last_test") == "test"
  end
end
