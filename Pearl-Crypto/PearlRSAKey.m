/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

#ifdef PEARL_WITH_OPENSSL

#include <openssl/err.h>
#include <openssl/ssl.h>
#include <openssl/pkcs12.h>

#define rsaKey ((RSA *)_key)
#define rsaKeyIn ((RSA **)&_key)


@interface PearlRSAKey ()

- (BOOL)isValid;

- (X509_REQ *)csrForSubject:(NSDictionary *)x509Subject hashWith:(PearlHash)hash;

@end

@implementation PearlRSAKey
@synthesize isPublicKey = _isPublicKey;

+ (void)initialize {

    CRYPTO_malloc_init();
    ERR_load_crypto_strings();
    OpenSSL_add_all_algorithms();
}

static NSString *NSStringFromOpenSSLErrors() {

    BIO *bio = BIO_new(BIO_s_mem());
    ERR_print_errors(bio);

    size_t length = BIO_ctrl_pending(bio);
    unsigned char *buffer = malloc(length);
    BIO_read(bio, buffer, (int)length);

    return [[NSString alloc] initWithBytes:buffer length:length encoding:NSUTF8StringEncoding];
}

static NSString *toHexString(id object) {

    if (NullToNil(object) == nil)
        return nil;

    if ([object isKindOfClass:[NSData class]])
        return [object encodeHex];

    if ([object isKindOfClass:[NSString class]])
        return object;

    err(@"Cannot convert to hex: %@", object);
    return nil;
}

static size_t pem_password_callback(char *buf, size_t bufsiz, int verify, char *keyPhrase) {

    size_t length = strlen(keyPhrase);
    if (length > bufsiz)
        length = bufsiz;

    memcpy(buf, keyPhrase, length);
    return length;
}

static const EVP_MD *EVP_md(PearlHash hash) {

    switch (hash) {
        case PearlHashNone:
            return NULL;
        case PearlHashMD4:
            return EVP_md4();
        case PearlHashMD5:
            return EVP_md5();
        case PearlHashSHA1:
            return EVP_sha1();
        case PearlHashSHA224:
            return EVP_sha224();
        case PearlHashSHA256:
            return EVP_sha256();
        case PearlHashSHA384:
            return EVP_sha384();
        case PearlHashSHA512:
            return EVP_sha512();
        case PearlHashCount:
            break;
    }

    err(@"Unsupported hash function: %d", hash);
    return 0;
}

- (id)init {

    return [self initWithKeyLength:1024];
}

- (id)initWithKeyLength:(NSUInteger)keyBitLength {

    if (!(self = [super init]))
        return nil;

    self.isPublicKey = NO;

    _key = RSA_generate_key((int)keyBitLength, RSA_F4, NULL, NULL);

    if (![self isValid])
        return self = nil;

    return self;
}

- (void)dealloc {

    if (rsaKey)
        RSA_free(rsaKey);
}

- (id)initWithHexModulus:(NSString *)hexModulus privateExponent:(NSString *)hexExponent {

    if (!(self = [super init]))
        return nil;

    self.isPublicKey = NO;

    _key = RSA_new();
    if (!rsaKey) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return self = nil;
    }

    BN_hex2bn(&(rsaKey->n), [hexModulus cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->e), [@"10001" cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->d), [hexExponent cStringUsingEncoding:NSUTF8StringEncoding]);

    if (![self isValid])
        return self = nil;

    return self;
}

- (id)initWithBinaryModulus:(NSData *)modulus privateExponent:(NSData *)exponent {

    if (!(self = [super init]))
        return nil;

    self.isPublicKey = NO;

    _key = RSA_new();
    if (!rsaKey) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return self = nil;
    }

    rsaKey->n = BN_bin2bn(modulus.bytes, (int)modulus.length, NULL);
    BN_hex2bn(&(rsaKey->e), [@"10001" cStringUsingEncoding:NSUTF8StringEncoding]);
    rsaKey->d = BN_bin2bn(exponent.bytes, (int)exponent.length, NULL);

    if (![self isValid])
        return self = nil;

    return self;
}

- (id)initWithHexModulus:(NSString *)hexModulus privateExponent:(NSString *)hexExponent
                  primeP:(NSString *)hexPrimeP primeQ:(NSString *)hexPrimeQ {

    if (!(self = [super init]))
        return nil;

    self.isPublicKey = NO;

    _key = RSA_new();
    if (!rsaKey) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return self = nil;
    }

    BN_hex2bn(&(rsaKey->n), [hexModulus cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->e), [@"10001" cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->d), [hexExponent cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->p), [hexPrimeP cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->q), [hexPrimeQ cStringUsingEncoding:NSUTF8StringEncoding]);

    if (![self isValid])
        return self = nil;

    return self;
}

- (id)initWithBinaryModulus:(NSData *)modulus privateExponent:(NSData *)exponent
                     primeP:(NSData *)primeP primeQ:(NSData *)primeQ {

    if (!(self = [super init]))
        return nil;

    self.isPublicKey = NO;

    _key = RSA_new();
    if (!rsaKey) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return self = nil;
    }

    rsaKey->n = BN_bin2bn(modulus.bytes, (int)modulus.length, NULL);
    BN_hex2bn(&(rsaKey->e), [@"10001" cStringUsingEncoding:NSUTF8StringEncoding]);
    rsaKey->d = BN_bin2bn(exponent.bytes, (int)exponent.length, NULL);
    rsaKey->p = BN_bin2bn(primeP.bytes, (int)primeP.length, NULL);
    rsaKey->q = BN_bin2bn(primeQ.bytes, (int)primeQ.length, NULL);

    if (![self isValid])
        return self = nil;

    return self;
}

- (id)initWithHexModulus:(NSString *)hexModulus publicExponent:(NSString *)hexExponent {

    if (!(self = [super init]))
        return nil;

    self.isPublicKey = YES;

    _key = RSA_new();
    if (!rsaKey) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return self = nil;
    }

    BN_hex2bn(&(rsaKey->n), [hexModulus cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->e), [hexExponent cStringUsingEncoding:NSUTF8StringEncoding]);

    if (![self isValid])
        return self = nil;

    return self;
}

- (id)initWithBinaryModulus:(NSData *)modulus publicExponent:(NSData *)exponent {

    if (!(self = [super init]))
        return nil;

    self.isPublicKey = YES;

    _key = RSA_new();
    if (!rsaKey) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return self = nil;
    }

    rsaKey->n = BN_bin2bn(modulus.bytes, (int)modulus.length, NULL);
    rsaKey->e = BN_bin2bn(exponent.bytes, (int)exponent.length, NULL);

    if (![self isValid])
        return self = nil;

    return self;
}

- (id)initWithDEREncodedASN1:(NSData *)derEncodedKey isPublic:(BOOL)isPublicKey {

    if (!(self = [super init]))
        return nil;

    const unsigned char *derEncodedBytes = (const unsigned char *)derEncodedKey.bytes;
    if ((self.isPublicKey = isPublicKey))
        _key = d2i_RSA_PUBKEY(NULL, &derEncodedBytes, (int)derEncodedKey.length);
    else
        _key = d2i_RSAPrivateKey(NULL, &derEncodedBytes, (int)derEncodedKey.length);

    if (![self isValid])
        return self = nil;

    return self;
}

- (id)initWithDEREncodedPKCS12:(NSData *)derEncodedKey keyPhrase:(NSString *)keyPhrase isPublic:(BOOL)isPublicKey {

    if (!(self = [super init]))
        return nil;

    self.isPublicKey = isPublicKey;

    const unsigned char *derEncodedBytes = (const unsigned char *)derEncodedKey.bytes;
    PKCS12              *pkcs12          = d2i_PKCS12(NULL, &derEncodedBytes, (int)derEncodedKey.length);
    if (!pkcs12) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return self = nil;
    }

    X509     *cert;
    EVP_PKEY *pkey                       = EVP_PKEY_new();
    if (!PKCS12_parse(pkcs12, [keyPhrase cStringUsingEncoding:NSUTF8StringEncoding], &pkey, &cert, NULL)) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    _key = pkey->pkey.rsa;

    if (![self isValid])
        return self = nil;

    return self;
}

- (id)initWithPEMEncodedPKCS12:(NSData *)pemEncodedKey keyPhrase:(NSString *)keyPhrase isPublic:(BOOL)isPublicKey {

    if (!(self    = [super init]))
        return nil;

    EVP_PKEY *pkey;
    BIO      *bio = BIO_new(BIO_s_mem());
    BIO_write(bio, pemEncodedKey.bytes, (int)pemEncodedKey.length);
    if ((self.isPublicKey = isPublicKey))
        pkey = PEM_read_bio_PUBKEY(bio, NULL, (pem_password_cb *)pem_password_callback,
                                   (void *)[keyPhrase cStringUsingEncoding:NSUTF8StringEncoding]);
    else
        pkey = PEM_read_bio_PrivateKey(bio, NULL, (pem_password_cb *)pem_password_callback,
                                       (void *)[keyPhrase cStringUsingEncoding:NSUTF8StringEncoding]);
    BIO_free(bio);
    _key = pkey->pkey.rsa;

    if (![self isValid])
        return self = nil;

    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {

    if (!(self = [super init]))
        return nil;

    _key = RSA_new();
    if (!rsaKey) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return self = nil;
    }

    NSString *n, *e, *d, *p, *q;
    if ((n = toHexString([dictionary objectForKey:@"n"])))
        BN_hex2bn(&(rsaKey->n), [n cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((e = toHexString([dictionary objectForKey:@"e"])))
        BN_hex2bn(&(rsaKey->e), [e cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((d = toHexString([dictionary objectForKey:@"d"])))
        BN_hex2bn(&(rsaKey->d), [d cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((p = toHexString([dictionary objectForKey:@"p"])))
        BN_hex2bn(&(rsaKey->p), [p cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((q = toHexString([dictionary objectForKey:@"q"])))
        BN_hex2bn(&(rsaKey->q), [q cStringUsingEncoding:NSUTF8StringEncoding]);
    self.isPublicKey = (d == nil);

    if (![self isValid])
        return self = nil;

    return self;
}

- (PearlRSAKey *)publicKey {

    if (self.isPublicKey)
        return self;

    return [[PearlRSAKey alloc] initWithHexModulus:[self modulus] publicExponent:[self publicExponent]];
}

- (int)maxSize {

    return RSA_size(rsaKey);
}

- (BOOL)isValid {

    if (!rsaKey)
        return NO;
    if (self.isPublicKey || !rsaKey->p)
     // Cannot use check_key on public keys or private keys without known p & q.
        return [[self modulus] length] && [[self privateExponent] length];

    int check = RSA_check_key(rsaKey);

    if (check == 0)
        return NO;
    if (check > 0)
        return YES;

    err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
    return NO;
}

- (NSString *)modulus {

    return [NSString stringWithCString:BN_bn2hex(rsaKey->n) encoding:NSUTF8StringEncoding];
}

- (NSString *)privateExponent {

    if (self.isPublicKey)
        return [NSString stringWithCString:BN_bn2hex(rsaKey->e) encoding:NSUTF8StringEncoding];
    else
        return [NSString stringWithCString:BN_bn2hex(rsaKey->d) encoding:NSUTF8StringEncoding];

}

- (NSString *)publicExponent {

    return [NSString stringWithCString:BN_bn2hex(rsaKey->e) encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionaryRepresentation {

    NSMutableDictionary *representation = [NSMutableDictionary dictionaryWithCapacity:5];

    if (rsaKey->n)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->n) encoding:NSUTF8StringEncoding] decodeHex]
                        forKey:@"n"];
    if (rsaKey->e)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->e) encoding:NSUTF8StringEncoding] decodeHex]
                        forKey:@"e"];
    if (rsaKey->d)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->d) encoding:NSUTF8StringEncoding] decodeHex]
                        forKey:@"d"];
    if (rsaKey->p)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->p) encoding:NSUTF8StringEncoding] decodeHex]
                        forKey:@"p"];
    if (rsaKey->q)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->q) encoding:NSUTF8StringEncoding] decodeHex]
                        forKey:@"q"];

    return representation;
}

- (BOOL)isEqual:(id)object {

    return [object isKindOfClass:[self class]] && [[self description] isEqual:[object description]];
}

- (NSString *)description {

    return [[self dictionaryRepresentation] description];
}

- (NSData *)derExportASN1 {

    size_t length;
    unsigned char *bufferOut, *bufferIn;

    if (self.isPublicKey) {
        length   = (size_t)i2d_RSA_PUBKEY(rsaKey, NULL);
        bufferIn = bufferOut = (unsigned char *)malloc(length);
        i2d_RSA_PUBKEY(rsaKey, &bufferIn);
    } else {
        length   = (size_t)i2d_RSAPrivateKey(rsaKey, NULL);
        bufferIn = bufferOut = (unsigned char *)malloc(length);
        i2d_RSAPrivateKey(rsaKey, &bufferIn);
    }

    return [NSData dataWithBytes:bufferOut length:length];
}

- (NSData *)derExportPKCS12WithName:(NSString *)friendlyName encryptWithKeyPhrase:(NSString *)keyPhrase {

    // Convert to PKCS12
    EVP_PKEY *pkey = EVP_PKEY_new();
    EVP_PKEY_assign_RSA(pkey, rsaKey);

    PKCS12 *pkcs12;
    if (keyPhrase)
        pkcs12 = PKCS12_create((char *)[keyPhrase cStringUsingEncoding:NSUTF8StringEncoding],
                               friendlyName? (char *)[friendlyName cStringUsingEncoding:NSUTF8StringEncoding]: NULL,
                               pkey, NULL, NULL, 0, 0, PKCS12_DEFAULT_ITER, PKCS12_DEFAULT_ITER, 0);
    else
        pkcs12 = PKCS12_create(NULL,
         friendlyName? (char *)[friendlyName cStringUsingEncoding:NSUTF8StringEncoding]: NULL,
         pkey, NULL, NULL, -1, -1, PKCS12_DEFAULT_ITER, PKCS12_DEFAULT_ITER, 0);
    if (!pkcs12) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    // Export to DER
    size_t length = (size_t)i2d_PKCS12(pkcs12, NULL);
    unsigned char *bufferOut, *bufferIn;
    bufferOut = bufferIn = malloc(length);
    if (!i2d_PKCS12(pkcs12, &bufferIn)) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    return [NSData dataWithBytes:bufferOut length:length];
}

- (NSData *)pemExport:(NSString *)friendlyName encryptWithKeyPhrase:(NSString *)keyPhrase {

    // Write to BIO
    BIO *bio = BIO_new(BIO_s_mem());
    if (keyPhrase) {
        if (!PEM_write_bio_RSAPrivateKey(bio, rsaKey, EVP_des_ede3_cbc(),
                                         (unsigned char *)[keyPhrase cStringUsingEncoding:NSUTF8StringEncoding], (int)[keyPhrase length],
         NULL, NULL)) {
            err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
            return nil;
        }
    } else {
        if (!PEM_write_bio_RSAPrivateKey(bio, rsaKey, NULL, NULL, 0, NULL, NULL)) {
            err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
            return nil;
        }
    }

    // Read into buffer
    size_t length = (size_t)BIO_ctrl_pending(bio);
    unsigned char *buffer = malloc(length);
    BIO_read(bio, buffer, (int)length);
    BIO_free(bio);

    return [NSData dataWithBytes:buffer length:length];
}

- (NSData *)encryptPlainData:(NSData *)data {

    size_t length;
    unsigned char *buffer = (unsigned char *)malloc((size_t)RSA_size(rsaKey));

    if (self.isPublicKey)
        length = (size_t)RSA_public_encrypt((int)data.length, data.bytes, buffer, rsaKey, RSA_PKCS1_PADDING);
    else
        length = (size_t)RSA_private_encrypt((int)data.length, data.bytes, buffer, rsaKey, RSA_PKCS1_PADDING);

    if (length > 0)
        return [NSData dataWithBytes:buffer length:length];

    err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
    return nil;
}

- (NSData *)decryptCipherData:(NSData *)data {

    size_t length;
    unsigned char *buffer = (unsigned char *)malloc((size_t)RSA_size(rsaKey));

    if (self.isPublicKey)
        length = (size_t)RSA_public_decrypt((int)data.length, data.bytes, buffer, rsaKey, RSA_PKCS1_PADDING);
    else
        length = (size_t)RSA_private_decrypt((int)data.length, data.bytes, buffer, rsaKey, RSA_PKCS1_PADDING);

    if (length > 0)
        return [NSData dataWithBytes:buffer length:length];

    err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
    return nil;
}

- (NSData *)signData:(NSData *)data hashWith:(PearlHash)hash {

    /* Initialize Context */
    EVP_PKEY *pkey = EVP_PKEY_new();
    EVP_PKEY_assign_RSA(pkey, rsaKey);
    EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(pkey, NULL);
    if (!ctx) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    if (EVP_PKEY_sign_init(ctx) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_PADDING) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    if (EVP_PKEY_CTX_set_signature_md(ctx, EVP_md(hash)) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    /* Perform Operation */
    NSData *hash = [data hashWith:hash];
    size_t length;
    if (EVP_PKEY_sign(ctx, NULL, &length, hash.bytes, hash.length) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    unsigned char *buffer = OPENSSL_malloc(length);
    if (!buffer)
        return nil;

    if (EVP_PKEY_sign(ctx, buffer, &length, hash.bytes, hash.length) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    return [NSData dataWithBytes:buffer length:length];
}

- (BOOL)verifySignature:(NSData *)signature ofData:(NSData *)data hashWith:(PearlHash)hash {

    /* Initialize Context */
    EVP_PKEY *pkey = EVP_PKEY_new();
    EVP_PKEY_assign_RSA(pkey, rsaKey);
    EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(pkey, NULL);
    if (!ctx) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return NO;
    }

    if (EVP_PKEY_sign_init(ctx) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return NO;
    }

    if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_PADDING) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return NO;
    }

    if (EVP_PKEY_CTX_set_signature_md(ctx, EVP_md(hash)) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return NO;
    }

    /* Perform Operation */
    NSData *hash = [data hashWith:hash];
    if (EVP_PKEY_verify(ctx, signature.bytes, signature.length, hash.bytes, hash.length))
        return YES;

    err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
    return NO;
}

- (NSData *)verifySignature:(NSData *)signature recoverDataHashedWith:(PearlHash)hash {

    /* Initialize Context */
    EVP_PKEY *pkey = EVP_PKEY_new();
    EVP_PKEY_assign_RSA(pkey, rsaKey);
    EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(pkey, NULL);
    if (!ctx) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    if (EVP_PKEY_sign_init(ctx) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_PADDING) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    if (EVP_PKEY_CTX_set_signature_md(ctx, EVP_md(hash)) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    /* Perform Operation */
    size_t length;
    if (EVP_PKEY_verify_recover(ctx, NULL, &length, signature.bytes, signature.length) <= 0) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    unsigned char *buffer = OPENSSL_malloc(length);
    if (!buffer)
        return nil;

    if (EVP_PKEY_verify_recover(ctx, buffer, &length, signature.bytes, signature.length))
        return [NSData dataWithBytes:buffer length:length];

    err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
    return nil;
}

- (X509_REQ *)csrForSubject:(NSDictionary *)x509Subject hashWith:(PearlHash)hash {

    X509_REQ *csr = X509_REQ_new();
    if (!csr) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    // Version
    if (!X509_REQ_set_version(csr, 0L)) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    // Subject Name
    X509_NAME *dn = X509_NAME_new();
    if (!dn) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }
    for (id subjectKey in [x509Subject allKeys]) {
        NSString *subjectValue = [[x509Subject objectForKey:subjectKey] description];

        if (!X509_NAME_add_entry_by_txt(dn, [[subjectKey description] UTF8String], MBSTRING_ASC,
                                        (unsigned char *)[subjectValue UTF8String],
                                        (int)[subjectValue length], -1, 0)) {
            err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
            return nil;
        }
    }
    if (!X509_REQ_set_subject_name(csr, dn)) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }
    X509_NAME_free(dn);

    // Owner's public key
    EVP_PKEY *pkey = EVP_PKEY_new();
    EVP_PKEY_assign_RSA(pkey, rsaKey);
    if (!pkey) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }
    if (!X509_REQ_set_pubkey(csr, pkey)) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    // Sign
    if (!X509_REQ_sign(csr, pkey, EVP_md(hash))) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    // Verify
    if (!X509_REQ_verify(csr, pkey)) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }

    return csr;
}

- (NSData *)derEncodedCSRForSubject:(NSDictionary *)x509Subject hashWith:(PearlHash)hash {

    X509_REQ *csr                    = [self csrForSubject:x509Subject hashWith:hash];

    // Export
    unsigned char *bufferOut, *bufferIn;
    size_t                    length = (size_t)i2d_X509_REQ(csr, NULL);
    bufferIn = bufferOut = (unsigned char *)malloc(length);
    i2d_X509_REQ(csr, &bufferIn);

    // Free
    X509_REQ_free(csr);

    return [NSData dataWithBytes:bufferOut length:length];
}


- (NSData *)pemEncodedCSRForSubject:(NSDictionary *)x509Subject hashWith:(PearlHash)hash {

    X509_REQ *csr = [self csrForSubject:x509Subject hashWith:hash];

    // Export
    BIO *bio = BIO_new(BIO_s_mem());
    if (!PEM_write_bio_X509_REQ(bio, csr)) {
        err(@"[OpenSSL] %@", NSStringFromOpenSSLErrors());
        return nil;
    }
    size_t length = BIO_ctrl_pending(bio);
    unsigned char *buffer = malloc(length);
    BIO_read(bio, buffer, (int)length);

    // Free
    BIO_free(bio);
    X509_REQ_free(csr);

    return [NSData dataWithBytes:buffer length:length];
}


@end

#endif
