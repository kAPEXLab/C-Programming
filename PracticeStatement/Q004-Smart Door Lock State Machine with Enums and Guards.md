# Title: Smart Door Lock State Machine with Enums and Guards  
## Level: Difficult  
## Concepts: Enums, State Machines, Guard Conditions, Counters  

---  

## Scenario  
You are implementing a smart door lock controller. The lock reacts to commands, motor feedback, sensor events, and battery status. Safety guards (low‑power, forced‑open, timeout, etc.) must be evaluated before normal state transitions. The function must compute the next lock state, the action to perform, and update the command‑attempt counter.

---  

## Problem Statement  
Create a deterministic, guard‑first state‑step function that, given the current state, an incoming event, battery status, and the current attempt count, returns the next state, the required action, and the updated attempt counter. All enums and pointers must be validated; on error no output values are modified.

---  

## Requirements  

* Enumerations  

  ```c
  enum LockState { ST_LOCKED, ST_UNLOCKED, ST_MOVING_LOCK,
                   ST_MOVING_UNLOCK, ST_ALARM, ST_LOWPOWER };
                   
  enum LockEvent { EV_LOCK_CMD, EV_UNLOCK_CMD, EV_MOTOR_DONE_OK,
                   EV_MOTOR_STALL, EV_FORCED_OPEN, EV_TIMEOUT,
                   EV_BATTERY_LOW, EV_BATTERY_OK };
                   
  enum Action    { ACT_NONE, ACT_START_LOCK, ACT_START_UNLOCK,
                   ACT_SOUND_ALARM, ACT_ENTER_SLEEP };
  ```

* Guard / policy handling (evaluated **first**)  

  * If `battery_low == true` and the current state is **not** `ST_ALARM`,
    any `EV_BATTERY_LOW` forces transition to `ST_LOWPOWER` with action
    `ACT_ENTER_SLEEP`.  
  * From `ST_LOWPOWER`, `EV_BATTERY_OK` → `ST_UNLOCKED`, action `ACT_NONE`.  
  * Any state receiving `EV_FORCED_OPEN` → `ST_ALARM`, action `ACT_SOUND_ALARM`.  
  * In moving states (`ST_MOVING_LOCK`, `ST_MOVING_UNLOCK`) the following
    apply:  
    - `EV_MOTOR_DONE_OK` → respective locked/unlocked state, action `ACT_NONE`.  
    - `EV_MOTOR_STALL` → `ST_ALARM`, action `ACT_SOUND_ALARM`.  
    - `EV_TIMEOUT` → `ST_ALARM`, action `ACT_SOUND_ALARM`.  

* Command handling  

  * `ST_UNLOCKED` + `EV_LOCK_CMD` → `ST_MOVING_LOCK`, action `ACT_START_LOCK`.  
  * `ST_LOCKED`   + `EV_UNLOCK_CMD` → `ST_MOVING_UNLOCK`, action `ACT_START_UNLOCK`.  

* Attempt counter  

  * If `attempts >= 3` **and** the incoming event is a command
    (`EV_LOCK_CMD` or `EV_UNLOCK_CMD`), the command is ignored: stay in the
    current state, action `ACT_NONE`, and `attempts` is unchanged.  
  * When a command is accepted, increment `attempts` by one and return the
    new value via `out_attempts_next`.  
  * Upon successful motor completion (`EV_MOTOR_DONE_OK`) or any transition
    to a non‑moving state (`ST_LOCKED`, `ST_UNLOCKED`, `ST_ALARM`,
    `ST_LOWPOWER`), reset `attempts` to 0.

* Validation  

  * All enum arguments must be within their defined ranges.  
  * Pointers `out_next`, `out_action`, and `out_attempts_next` must be
    non‑NULL.  
  * On any validation failure, return `-1` and leave output parameters
    unchanged.

---  

## Function Details  

**Name**  
`lock_step`  

**Arguments**  

* `enum LockState curr` – current lock state.  
* `enum LockEvent ev` – incoming event.  
* `bool battery_low` – current battery status (true = low).  
* `int attempts` – current consecutive command‑attempt count (≥ 0).  
* `enum LockState *out_next` – pointer to receive the next state.  
* `enum Action *out_action` – pointer to receive the action to perform.  
* `int *out_attempts_next` – pointer to receive the updated attempts count.  

**Return Value**  
`int` – `0` on success, `-1` on invalid arguments or invalid enum values.  

**Description**  
The function first checks the guard conditions (battery‑low, forced‑open, etc.),
then processes state‑specific transitions. It updates the attempt counter
according to the rules above, writes the results through the provided pointers,
and returns `0`. If any validation fails, it returns `-1` without modifying the
output parameters.

---  

## Solution Approach  

1. **Validate pointers** (`out_next`, `out_action`, `out_attempts_next`).  
2. **Validate enums** by ensuring the integer values fall within the defined
   ranges of each enumeration.  
3. **Handle battery‑low guard**: if `battery_low && ev == EV_BATTERY_LOW &&
   curr != ST_ALARM`, set next state `ST_LOWPOWER`, action
   `ACT_ENTER_SLEEP`, attempts unchanged, return success.  
4. **Handle low‑power recovery**: if `curr == ST_LOWPOWER && ev == EV_BATTERY_OK`,
   transition to `ST_UNLOCKED`, action `ACT_NONE`.  
5. **Handle forced‑open**: any state + `EV_FORCED_OPEN` → `ST_ALARM`,
   action `ACT_SOUND_ALARM`.  
6. **Process command events** (`EV_LOCK_CMD`, `EV_UNLOCK_CMD`):  
   * If `attempts >= 3`, ignore command (stay in `curr`, action `ACT_NONE`,
     attempts unchanged).  
   * Otherwise, apply the command mapping (unlock → moving‑unlock, lock → moving‑lock),
     increment attempts, and set the corresponding start action.  
7. **Process motor feedback** for moving states:  
   * `EV_MOTOR_DONE_OK` → locked/unlocked state, action `ACT_NONE`,
     attempts reset to 0.  
   * `EV_MOTOR_STALL` or `EV_TIMEOUT` → `ST_ALARM`, action
     `ACT_SOUND_ALARM`, attempts reset to 0.  
8. **Default** – if no rule matches, remain in current state with
   `ACT_NONE` and attempts unchanged.  
9. Write results to the output pointers and return `0`.  

---  

## Tasks to Perform  

1. Define the three enumerations (`LockState`, `LockEvent`, `Action`).  
2. Implement `lock_step` exactly as described, using only `int`, `bool`, and `enum` types.  
3. Ensure no fall‑through in `switch` statements; each case must end with a `break` or explicit `return`.  
4. Write unit tests covering all guard conditions, normal commands,
   attempt‑limit handling, motor feedback, timeout, forced‑open, low‑power entry
   and exit, and invalid‑argument cases.  

---  

## Test Cases

1. **Normal lock command**  
   *Input*: `curr = ST_UNLOCKED`, `ev = EV_LOCK_CMD`, `battery_low = false`,
   `attempts = 0`  
   *Expected*: return 0, `*out_next = ST_MOVING_LOCK`,
   `*out_action = ACT_START_LOCK`, `*out_attempts_next = 1`.

2. **Motor completes lock**  
   *Input*: `curr = ST_MOVING_LOCK`, `ev = EV_MOTOR_DONE_OK`,
   `battery_low = false`, `attempts = 1`  
   *Expected*: return 0, `*out_next = ST_LOCKED`,
   `*out_action = ACT_NONE`, `*out_attempts_next = 0`.

3. **Command ignored due to attempt limit**  
   *Input*: `curr = ST_LOCKED`, `ev = EV_UNLOCK_CMD`,
   `battery_low = false`, `attempts = 3`  
   *Expected*: return 0, `*out_next = ST_LOCKED`,
   `*out_action = ACT_NONE`, `*out_attempts_next = 3`.

4. **Timeout while moving**  
   *Input*: `curr = ST_MOVING_UNLOCK`, `ev = EV_TIMEOUT`,
   `battery_low = false`, `attempts = 1`  
   *Expected*: return 0, `*out_next = ST_ALARM`,
   `*out_action = ACT_SOUND_ALARM`, `*out_attempts_next = 0`.

5. **Forced open security breach**  
   *Input*: `curr = ST_LOCKED`, `ev = EV_FORCED_OPEN`,
   `battery_low = false`, `attempts = 0`  
   *Expected*: return 0, `*out_next = ST_ALARM`,
   `*out_action = ACT_SOUND_ALARM`, `*out_attempts_next = 0`.

6. **Enter low‑power mode**  
   *Input*: `curr = ST_UNLOCKED`, `ev = EV_BATTERY_LOW`,
   `battery_low = true`, `attempts = 0`  
   *Expected*: return 0, `*out_next = ST_LOWPOWER`,
   `*out_action = ACT_ENTER_SLEEP`, `*out_attempts_next = 0`.

7. **Recover from low‑power**  
   *Input*: `curr = ST_LOWPOWER`, `ev = EV_BATTERY_OK`,
   `battery_low = false`, `attempts = 0`  
   *Expected*: return 0, `*out_next = ST_UNLOCKED`,
   `*out_action = ACT_NONE`, `*out_attempts_next = 0`.

8. **Invalid enum argument**  
   *Input*: `curr = (enum LockState)99`, `ev = EV_LOCK_CMD`,
   `battery_low = false`, `attempts = 0`,
   any valid pointer arguments.  
   *Expected*: return -1, no modification of output parameters.