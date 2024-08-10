interface QSOptions {
    delimiter?: string;
}

export  function stringify(obj: any, options?: QSOptions): string {
    const delimiter = options?.delimiter || '&';

    const keyValuePairs = [];

    for (const key in obj) {
        if (obj.hasOwnProperty(key)) {
            const value = obj[key];
            const encodedKey = encodeURIComponent(key);
            const encodedValue = encodeURIComponent(value);
            keyValuePairs.push(`${encodedKey}=${encodedValue}`);
        }
    }

    return keyValuePairs.join(delimiter);
}

export function parse(str: string, options?: QSOptions): any {
    const delimiter = options?.delimiter || '&';

    const keyValuePairs = str.split(delimiter);
    const result = {};

    for (const pair of keyValuePairs) {
        const [encodedKey, encodedValue] = pair.split('=');
        const key = decodeURIComponent(encodedKey);
        const value = decodeURIComponent(encodedValue);
        result[key] = value;
    }

    return result;
}