from board import Board
from math import sqrt, log
from random import choice
from multiprocessing import Pool
from threading import Lock
from copy import deepcopy
import time

priority_table = [[(0, 0), (0, 7), (7, 0), (7, 7)],
                  [(0, 2), (0, 5), (7, 2), (7, 5), (2, 0), (5, 0), (2, 7), (5, 7)],
                  [(0, 3), (0, 4), (7, 3), (7, 4), (3, 0), (4, 0), (3, 7), (4, 7)],
                  [(2, 2), (2, 5), (5, 2), (5, 5)],
                  [(2, 3), (2, 4), (5, 3), (5, 4), (3, 2), (4, 2), (3, 5), (4, 5)],
                  [(1, 2), (1, 5), (6, 2), (6, 5), (2, 1), (5, 1), (2, 6), (5, 6)],
                  [(1, 3), (1, 4), (6, 3), (6, 4), (3, 1), (4, 1), (3, 6), (4, 6)],
                  [(0, 1), (0, 6), (7, 1), (7, 6), (1, 0), (6, 0), (1, 7), (6, 7)],
                  [(1, 1), (1, 6), (6, 1), (6, 6)]]


class MCTNode:
    """
    Definition of Monte Carlo Tree's node
    """

    def __init__(self, state, color, depth=0, parent=None, prev=None):
        """
        :param state: 8x8 matrix board
        :param color: current player's color
        :param depth: depth in the tree
        :param parent: parent
        :param prev: previous move
        """

        self.state = state
        self.color = color
        self.depth = depth
        self.parent = parent
        self.prev = prev

        self.children = []

        self.N = 0  # visit time of each node
        self.Q = 0  # reward of each node

        self.optional_move = list(state.get_legal_actions(self.color))

    def add_child(self, move):
        """
        add a child to this node
        :param move: move to get next state
        """
        self.optional_move.remove(move)
        child_state = deepcopy(self.state)
        child_state._move(move, self.color)
        child_color = "X" if self.color == "O" else "O"
        child = MCTNode(child_state, child_color,
                        self.depth + 1, self, move)
        self.children.append(child)

    def ucb1(self, c):
        """
        return the best child
        :param c: constant
        :return: [value, child]
        """
        child_value = [child.Q / child.N + sqrt(c * log(self.N) / child.N) for child in self.children]
        value = max(child_value)
        idx = child_value.index(value)
        return value, self.children[idx]

    def random_child(self):
        """
        return a random child
        :return: random chosen child's move method
        """
        child_move = choice(self.optional_move)
        return child_move

    def is_full_expand(self) -> bool:
        """
        return whether this node has been fully expanded
        """
        return len(self.optional_move) == 0

    def is_terminal(self) -> bool:
        """
        return whether this node's state is terminated
        """
        return len(self.optional_move) == 0 and len(self.children) == 0


class MCTSearch:
    """
    Definition of Monte Carlo Tree Search procedure
    """

    def __init__(self, board, color, cp=2):
        """
        :param board: 8x8 matrix board
        :param color: origin player's color
        :param cp: constance used for ucb1
        """

        self.board = board
        self.color = color
        self.cp = cp

        self.root = MCTNode(self.board, color, 0)
        self.depth = 0
        self.start_time = 0
        self.max_time = 55

        self.iter_times = 0
        self.max_iter_times = 50

    def uct_search(self):
        """
        uct search for best move
        :return: action with maximum win rate
        """
        self.start_time = time.time()

        while not self.root.is_full_expand():
            v = self.select_policy(self.root)
            reward = self.simulate_policy(v)
            self.back_propagate(v, reward)
        # print('root full expanded, time cost %f' % time.time() - self.start_time)

        pool = Pool(processes=len(self.root.children))
        pool.map(self.search, self.root.children)
        pool.close()
        pool.join()

        win_rate, best_node = self.root.ucb1(self.cp)
        # print("win rate is", win_rate)
        return best_node.prev

    def search(self, node):
        """
        :param node: root node
        :return: count
        """
        while time.time() - self.start_time < self.max_time and self.iter_times < self.max_iter_times:
            v = self.select_policy(node)
            if not v:
                break
            reward = self.simulate_policy(v)
            self.back_propagate(v, reward)
            self.iter_times += 1

    def select_policy(self, node):
        """
        :param node: start node v0
        :return: end node v
        """
        while not node.is_terminal():
            if node.is_full_expand():
                value, node = node.ucb1(self.cp)
            else:
                return self.expand(node)

    def simulate_policy(self, node):
        """
        :param node: start node v0
        :return: win or lose
        """
        cur_board = deepcopy(node.state)
        cur_color = node.color
        while not self.is_game_over(cur_board):
            optional_move = list(cur_board.get_legal_actions(cur_color))
            if len(optional_move) != 0:
                # choice based on priority table
                priority_move = self.get_priority_move(cur_board, cur_color)
                choice_move = choice(priority_move)
                # random choice
                # choice_move = choice(optional_move)
                cur_board._move(choice_move, cur_color)
            cur_color = "X" if cur_color == "O" else "O"
        COLOR_TAG = ['X', 'O', node.color]
        winner = COLOR_TAG[cur_board.get_winner()[0]]
        return winner == node.color

    def back_propagate(self, node, reward):
        """
        :param node: start node v0
        :param reward: reward to back propagate
        """
        while node is not None:
            node.N += 1
            node.Q += reward if node.color == self.color else (1 - reward)
            node = node.parent

    def expand(self, node):
        """
        :param: node v to expand
        :return: chosen unexpanded node v'
        """
        chosen_move = choice(list(self.get_node_priority_move(node)))
        # chosen_move = node.random_child()
        node.add_child(chosen_move)
        if node.children[-1].depth > self.depth:
            self.depth = node.children[-1].depth
        return node.children[-1]

    def is_game_over(self, board) -> bool:
        if board.count('.') == 0:
            return True
        b = list(board.get_legal_actions('X'))
        w = list(board.get_legal_actions('O'))
        if not b and not w:
            return True
        return False

    def get_priority_move(self, board, color):
        valid_move = list(board.get_legal_actions(color))
        priority_move = []
        for priority in priority_table:
            for item in priority:
                move = board.num_board(item)
                if move in valid_move:
                    priority_move.append(move)
            if len(priority_move) > 0:
                break
        return priority_move

    def get_node_priority_move(self, node):
        valid_move = node.optional_move
        priority_move = []
        for priority in priority_table:
            for item in priority:
                move = node.state.num_board(item)
                if move in valid_move:
                    priority_move.append(move)
            if len(priority_move) > 0:
                break
        return priority_move


if __name__ == '__main__':
    # # test deepcopy
    # board = Board()
    # print(board.display())
    # new_borad = deepcopy(board)
    # new_borad._move("D3", "X")
    # print(board.display())
    # print(new_borad.display())

    board = Board()
    board.display()
    mcts = MCTSearch(board, "X", 2)
    print(mcts.uct_search())
