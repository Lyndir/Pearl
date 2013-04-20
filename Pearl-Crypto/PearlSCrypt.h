/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

#ifdef PEARL_WITH_SCRYPT
#import <Foundation/Foundation.h>

@interface PearlSCrypt : NSObject {
    double _fractionOfAvailableMemory;
    size_t _maximumMemory;
    double _time;
}

/**
 * The fraction of the system's RAM that the operation should consume.
 * 
 * Cannot be higher than 0.5.  Defaults to 0.5 if 0.
 */
@property(nonatomic, assign) double fractionOfAvailableMemory;
/**
 * The maximum amount of memory (in bytes) that the operation is allowed to consume.
 * 
 * Limits the memory selected by fractionOfAvailableMemory, if lower.
 * Defaults to unlimited if 0.
 */
@property(nonatomic, assign) size_t maximumMemory;
/**
 * The time (in seconds) that the operation should run for.  This is a multiplier for the amount of operations per second the CPU can compute.
 * 
 * Defaults to using the minimum of 32768 operations if 0.
 */
@property(nonatomic, assign) double time;

/**
 * Initialize SCrypt with the default values for the cost limits.
 */
- (id)init;
/**
 * Initialize SCrypt with the given values for the cost limits.
 */
- (id)initWithMemoryFraction:(double)fractionOfAvailableMemory maximum:(NSUInteger)maximumMemory time:(double)time;

/**
 * Derive a key with the given length from a given password using the given values for salt, N, r and p.
 * 
 * @param N CPU/memory cost.  Value depends on the system's available CPU and memory resources.  Increasing this value multiplies the CPU and memory cost.
 * @param r Size parameter. Recommended: 8.  Increase this value to multiply the memory cost without affecting CPU cost significantly.
 * @param p Parallelization parameter. Recommended: 1.  Increase this value to multiply the CPU cost without affecting memory cost significantly.
 */
+ (NSData *)deriveKeyWithLength:(NSUInteger)keyLength fromPassword:(NSData *)password usingSalt:(NSData *)salt
                              N:(uint64_t)N r:(uint32_t)r p:(uint32_t)p;

/**
 * Determine values for cost parameters N, r and p that adhere to this instance's cost limits when used on the current system.
 */
- (BOOL)determineParametersN:(uint64_t *)N r:(uint32_t *)r p:(uint32_t *)p;

/**
 * Derive a key with the given length from a given password using the given salt.
 */
- (NSData *)deriveKeyWithLength:(NSUInteger)keyLength fromPassword:(NSData *)password usingSalt:(NSData *)salt;

/**
 * AES encrypt the given plain data using the given password.  This will first derive a key from the password, taking this instance's cost limits into account when determining the cost parameters for the derivation.
 */
- (NSData *)encrypt:(NSData *)plain withPassword:(NSData *)password;
/**
 * AES decrypt the given encrypted data using the given password.  This will first derive the key from the password, using the cost parameters encoded in the encrypted data's scrypt header.  We will first determine whether the system is capable of deriving the key within this instance's currently set cost limits.
 */
- (NSData *)decrypt:(NSData *)encrypted withPassword:(NSData *)password;

@end

#endif
