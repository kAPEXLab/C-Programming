# 70 - Sensor Event Handler Dispatch - Medium

## Question Details
- Concept: Function pointers, callback dispatch, and tagged events
- Difficulty: Medium
- Domain: Industrial telemetry gateway
- Learning Objective: Route a validated event to the handler associated with its event type.

## Scenario
A gateway receives temperature and pressure events from remote instruments. It must invoke the matching registered handler without embedding each downstream action in the gateway.

## Function Details
- Define `SensorEvent` with an event type, channel ID, and numeric value.
- Define `SensorEventHandler` as a pointer to a function accepting `const SensorEvent *`.
- Function Name: `dispatch_sensor_event`
- Function Signature: `int dispatch_sensor_event(const SensorEvent *event, SensorEventHandler temperatureHandler, SensorEventHandler pressureHandler);`
- Temperature values are valid from -40.0 through 150.0 C; pressure values are valid from 0.0 through 2000.0 kPa.
- Dispatch a valid event to the matching non-null handler exactly once. Return 1 when dispatched; return 0 for an invalid event or missing handler.

## Tasks to Implement
1. Define the event type, event structure, and callback type.
2. Validate the event type and its value before dispatch.
3. Select only the callback matching the tag.
4. Do not call a handler for invalid data or a null handler.

## Test Cases
| Test Case ID | Input event | Expected Output: return; callback |
| --- | --- | --- |
| TC01 | TEMPERATURE, channel 2, 80.0; temp handler valid | 1; temp handler once |
| TC02 | PRESSURE, channel 4, 1250.0; pressure handler valid | 1; pressure handler once |
| TC03 | TEMPERATURE, channel 1, -40.0; temp handler valid | 1; temp handler once |
| TC04 | PRESSURE, channel 7, 2000.0; pressure handler valid | 1; pressure handler once |
| TC05 | TEMPERATURE, channel 1, 150.1; temp handler valid | 0; none |
| TC06 | PRESSURE, channel 3, -1.0; pressure handler valid | 0; none |
| TC07 | unknown event type, 25.0; both handlers valid | 0; none |
| TC08 | TEMPERATURE, channel 5, 25.0; temp handler null | 0; none |

## Expected Deliverables
- Definitions for the event structure and callback type.
- A complete implementation of `dispatch_sensor_event`.
- A short explanation of tagged callback dispatch.
- Test evidence for all eight cases.
