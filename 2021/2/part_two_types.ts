type Input = ['forward 5', 'down 5', 'forward 8', 'up 3', 'down 8', 'forward 2']
type Solve<CurrentArray, CurrentS> =
  CurrentS extends `forward ${infer N}`
    ? StringToNum<N>

    CurrentS extends `down ${infer N}`
  : never


/* Numbers */

interface AnyNum { prev?: any, zero?: boolean }
interface Zero { zero: true }
interface PositiveNum { prev: any, zero: false }

type Next<num extends AnyNum> = { prev: num, zero: false }
type Prev<num extends PositiveNum> = num['prev']

type Add<num extends AnyNum, toAdd extends AnyNum> =
  toAdd extends PositiveNum
    ? Add<Next<num>, Prev<toAdd>>
    : num

type Sub<num extends PositiveNum, toSub extends AnyNum> =
  toSub extends PositiveNum
    ? Sub<Prev<num>, Prev<toSub>>
    : num

type Multiply<num extends AnyNum, times extends PositiveNum> =
  times extends Next<Zero>
    ? num
    : Multiply<Add<num, num>, Prev<times>>

type Div<num extends PositiveNum, denom extends AnyNum> = TODO

/* String ops */
type StringToNum< acc extends number = ''> = TODO

type test = Multiply<Next<Next<Zero>>, Next<Next<Zero>>>

// type NumTable = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
// type NumTable1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
// type NextTable = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, never]
// type PrevTable = [never, 0, 2, 3, 4, 5, 6, 7, 8, 9]

// type Num = NumTable[number]

// type Next<T extends Num> = NextTable[T]
// type Prev<T extends Num> = PrevTable[T]

// type Add<num extends Num, toAdd extends Num> =
//   toAdd extends NumTable1[number]
//     ? num
//     : Next<Add<num, Prev<toAdd>>>

// type test = Add<1, 2>

// type ParseInt
