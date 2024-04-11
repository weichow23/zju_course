import time


class AIPlayer:
    """
    AI 玩家
    """

    def __init__(self, color):
        """
        玩家初始化
        :param color: 下棋方，'X' - 黑棋，'O' - 白棋
        """

        self.color = color

    def mctc_choice(self, board):
        action_list = list(board.get_legal_actions(self.color))
        # 如果 action_list 为空，则返回 None,否则通过蒙特卡洛树搜索返回结果
        if len(action_list) == 0:
            return None
        else:
            from MentoCarloTree import MCTSearch
            mcts = MCTSearch(board, self.color, 2)
            return mcts.uct_search()

    def get_move(self, board):
        """
        根据当前棋盘状态获取最佳落子位置
        :param board: 棋盘
        :return: action 最佳落子位置, e.g. 'A1'
        """
        if self.color == 'X':
            player_name = '黑棋'
        else:
            player_name = '白棋'
        print("请等一会，对方 {}-{} 正在思考中...".format(player_name, self.color))

        # -----------------请实现你的算法代码--------------------------------------
        start_time = time.time()
        action = self.mctc_choice(board)
        end_time = time.time()
        delta_time = end_time - start_time
        print("time cost for this step: {} ".format(delta_time))
        # ------------------------------------------------------------------------

        return action
