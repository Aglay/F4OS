#ifndef DEV_PERIPH_PX4_HMC5883_H_INCLUDED
#define DEV_PERIPH_PX4_HMC5883_H_INCLUDED

/* Mag readings in Gauss */
struct magnetometer {
    float x;
    float y;
    float z;
};

rd_t open_px4_hmc5883(void);
void read_px4_hmc5883(rd_t rd, struct magnetometer *mag);

#endif
