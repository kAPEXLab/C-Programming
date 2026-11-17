# 68 - Tagged Telemetry Frame - Medium

## Question Details
- Concept: typedef, enums, tagged unions, and field validation
- Difficulty: Medium
- Domain: Industrial instrumentation
- Scenario: A gateway receives one of several sensor-frame payload types and validates the active payload using its enum tag.
- Learning Objective: Associate the correct union member with a tag and validate only the active variant.

## Scenario
A telemetry gateway receives temperature, pressure, or status frames. Each frame stores one payload variant; the enum tag identifies which union member is valid, so interpreting the wrong member must be avoided.

## Function Details
- Define an enum `FrameType` with temperature, pressure, and status tags.
- Define `SensorFrame` using `typedef struct` and a union payload containing `temperatureMilliC`, `pressurePa`, and `statusCode` members.
- Function Name: `validate_sensor_frame`
- Function Signature: `int validate_sensor_frame(const SensorFrame *frame);`
- Temperature range: -40000..150000 milli-C; pressure range: 0..2000000 Pa; status code: 0..3.
- Return 1 for a recognized tag with an in-range active member; return 0 for a null pointer, unknown tag, or invalid value.

## Tasks to Implement
1. Define the enum, union, and tagged structure.
2. Switch on the tag before reading a union member.
3. Validate only the member selected by the tag.
4. Reject unknown tags and out-of-range values.

## Test Cases
| Test Case ID | Input: type, active payload value | Expected Output |
| --- | --- | --- |
| TC01 | TEMPERATURE, 25000 | 1 |
| TC02 | TEMPERATURE, -40000 | 1 |
| TC03 | TEMPERATURE, 150001 | 0 |
| TC04 | PRESSURE, 1200000 | 1 |
| TC05 | PRESSURE, -1 | 0 |
| TC06 | PRESSURE, 2000001 | 0 |
| TC07 | STATUS, 3 | 1 |
| TC08 | STATUS, 4 | 0 |
| TC09 | unknown tag, any payload | 0 |
| TC10 | null frame pointer | 0 |

## Expected Deliverables
- Definitions for the enum, tagged union, and `SensorFrame` type.
- A working implementation of `validate_sensor_frame`.
- A brief explanation of why the tag must be checked before accessing the union.
- Test evidence for all ten cases.
