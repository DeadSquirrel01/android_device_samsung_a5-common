/* secgps.conf parameters */
typedef struct sec_gps_cfg_s
{
    char      OPERATION_MODE[50];
} sec_gps_cfg_s_type;

typedef struct Sec_Configuration_s
{
    char      STUB[50];
} Sec_Configuration_s_type;

sec_gps_cfg_s_type sec_gps_conf = { .OPERATION_MODE = "MSBASED" };
Sec_Configuration_s_type Sec_Configuration = { .STUB = "" };
