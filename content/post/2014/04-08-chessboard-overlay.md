---
tags:
    - code
title: "Chessboard overlay"
date: "2014-04-08"
---

The chessboard overlay algorithm is from a textbook, different from the chessboard game algorithm.

The question: In a pow(2, k) * pow(2, k) chessboard, if there is a square different from others, then we call this square a special square. We use L shape blocks to cover the chessboard, and the amount of L shape is (pow(4, k) – 1) / 3. each L shape blocks contain 3 squares. for example:

  1 1 3 3
  1 2 -1 3
  5 2 2 4
  5 5 4 4

In the above chessboard, the -1 stand for special square, and other number is the identifier of each L shape blocks.

Ok, assuming we have understand the question.

If the size of the chessboard is 1, then we just return. if the size is 2, there are 4 squares, one is the special square, we just fill the other square with the identifier of L shape. So, the best way to do it is use Divide and conquer to divide the big chessboard into 2 size sub chessboard, fill each sub chessboard, then we done. but each sub chessboard will not all contain a special square, because there is only one special square. What should we do is fake one.

How to fake the special square? If we are processing the left top sub chessboard, then we make the right bottom square as fake special square if the real special square is not in this sub chessboard.( you can see why from the above chessboard). in the above chessboard, if we are processing the right top sub chessboard( size is 2 ), the real special is at the left bottom.
