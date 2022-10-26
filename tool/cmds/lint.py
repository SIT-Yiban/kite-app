from typing import Iterable

from cmd import CmdContext, CommandArgError
from flutter import Proj


def lint(ctx: CmdContext):
    pass


class LintCmd:
    name = "lint"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        lint(ctx)

    @staticmethod
    def execute_inter(ctx: CmdContext) -> Iterable:
        lint(ctx)
        yield

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "lint"
        t << "|-- format .dart files"
